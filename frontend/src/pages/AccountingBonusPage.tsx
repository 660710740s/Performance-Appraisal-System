import "../redesign.css";
import { useCallback, useEffect, useState, type FormEvent } from "react";
import client, { errorMessage } from "../api/client";
import type { Cycle } from "../types";

interface SalaryRow {
  employee_id: number;
  employee_name: string;
  amount: number | null;
  effective_date: string | null;
}

interface SalaryHistory {
  id: number;
  amount: number;
  effective_date: string;
  created_at: string;
}

interface Bonus {
  id: number;
  evaluation_id: number;
  cycle_id: number;
  employee_id: number;
  base_salary: number;
  total_score: number;
  suggested_amount: number;
  amount: number;
  status: "pending_approval" | "approved" | "rejected";
  note: string;
  decision_note: string;
}

// รูปแบบของ bonus-candidates ยังไม่ได้ตรวจกับ backend จึงรับแบบยืดหยุ่น
interface Candidate {
  id?: number;
  evaluation_id?: number;
  employee_id: number;
  employee_name?: string;
  total_score?: number;
}

const STATUS_LABEL = {
  pending_approval: "รอผู้บริหารอนุมัติ",
  approved: "อนุมัติแล้ว",
  rejected: "ไม่อนุมัติ",
};

const money = (n: number | null | undefined) =>
  n === null || n === undefined ? "-" : n.toLocaleString("th-TH");
const dateOnly = (iso: string | null) => (iso ? iso.slice(0, 10) : "-");

export default function AccountingBonusPage() {
  const [tab, setTab] = useState<"salary" | "bonus">("salary");
  const [salaries, setSalaries] = useState<SalaryRow[]>([]);
  const [cycles, setCycles] = useState<Cycle[]>([]);
  const [error, setError] = useState("");
  const [info, setInfo] = useState("");
  const [busy, setBusy] = useState(false);

  // เงินเดือน
  const [settingFor, setSettingFor] = useState<SalaryRow | null>(null);
  const [salaryAmount, setSalaryAmount] = useState("");
  const [salaryDate, setSalaryDate] = useState("");
  const [historyFor, setHistoryFor] = useState<SalaryRow | null>(null);
  const [history, setHistory] = useState<SalaryHistory[]>([]);

  // โบนัส
  const [cycleId, setCycleId] = useState("");
  const [candidates, setCandidates] = useState<Candidate[]>([]);
  const [bonuses, setBonuses] = useState<Bonus[]>([]);
  const [candAmount, setCandAmount] = useState<Record<number, string>>({});
  const [editId, setEditId] = useState<number | null>(null);
  const [editAmount, setEditAmount] = useState("");
  const [editNote, setEditNote] = useState("");

  const nameOf = (id: number) => salaries.find((s) => s.employee_id === id)?.employee_name ?? `#${id}`;

  const loadSalaries = useCallback(async () => {
    try {
      const res = await client.get("/accounting/salaries");
      setSalaries(res.data.data ?? []);
    } catch (err) {
      setError(errorMessage(err));
    }
  }, []);

  useEffect(() => {
    loadSalaries();
    client
      .get("/cycles")
      .then((res) => {
        const list: Cycle[] = res.data.data ?? [];
        setCycles(list);
        if (list.length > 0) setCycleId(String(list[0].id));
      })
      .catch((err) => setError(errorMessage(err)));
  }, [loadSalaries]);

  const loadBonus = useCallback(async () => {
    if (!cycleId) return;
    try {
      const [c, b] = await Promise.all([
        client.get("/accounting/bonus-candidates", { params: { cycle_id: cycleId } }),
        client.get("/accounting/bonuses", { params: { cycle_id: cycleId } }),
      ]);
      setCandidates(c.data.data ?? []);
      setBonuses(b.data.data ?? []);
    } catch (err) {
      setError(errorMessage(err));
    }
  }, [cycleId]);

  useEffect(() => {
    loadBonus();
  }, [loadBonus]);

  async function run(fn: () => Promise<void>, done: string) {
    setError("");
    setInfo("");
    setBusy(true);
    try {
      await fn();
      setInfo(done);
    } catch (err) {
      setError(errorMessage(err));
    } finally {
      setBusy(false);
    }
  }

  function submitSalary(e: FormEvent) {
    e.preventDefault();
    const amount = Number(salaryAmount);
    if (!settingFor) return;
    if (!salaryAmount || Number.isNaN(amount) || amount <= 0) {
      setError("เงินเดือนต้องมากกว่า 0");
      return;
    }
    if (!salaryDate) {
      setError("กรุณาเลือกวันที่มีผล");
      return;
    }
    run(async () => {
      await client.post("/accounting/salaries", {
        employee_id: settingFor.employee_id,
        amount,
        effective_date: `${salaryDate}T00:00:00Z`,
      });
      setSettingFor(null);
      setSalaryAmount("");
      setSalaryDate("");
      await loadSalaries();
    }, "บันทึกเงินเดือนแล้ว");
  }

  async function showHistory(row: SalaryRow) {
    setError("");
    setHistoryFor(row);
    try {
      const res = await client.get(`/accounting/salaries/${row.employee_id}/history`);
      setHistory(res.data.data ?? []);
    } catch (err) {
      setError(errorMessage(err));
    }
  }

  function createBonus(c: Candidate) {
    const evalId = c.evaluation_id ?? c.id;
    if (!evalId) return;
    const raw = candAmount[evalId];
    const body: Record<string, unknown> = { evaluation_id: evalId };
    if (raw !== undefined && raw !== "") {
      const n = Number(raw);
      if (Number.isNaN(n) || n < 0) {
        setError("ยอดโบนัสต้องเป็นตัวเลขและไม่ติดลบ");
        return;
      }
      body.amount = n;
    }
    run(async () => {
      await client.post("/accounting/bonuses", body);
      await loadBonus();
    }, "สร้างโบนัสแล้ว ส่งให้ผู้บริหารอนุมัติ");
  }

  function startEdit(b: Bonus) {
    setError("");
    setEditId(b.id);
    setEditAmount(String(b.amount));
    setEditNote(b.note ?? "");
  }

  function saveEdit() {
    const n = Number(editAmount);
    if (editId === null) return;
    if (editAmount === "" || Number.isNaN(n) || n < 0) {
      setError("ยอดโบนัสต้องเป็นตัวเลขและไม่ติดลบ");
      return;
    }
    run(async () => {
      await client.put(`/accounting/bonuses/${editId}`, { amount: n, note: editNote });
      setEditId(null);
      await loadBonus();
    }, "แก้ยอดโบนัสแล้ว");
  }

  return (
    <div style={{ maxWidth: 1000 }}>
      <h1>เงินเดือน / โบนัส</h1>
      <div style={{ display: "flex", gap: 8, margin: "12px 0" }}>
        <button className={tab === "salary" ? "btn-primary" : ""} onClick={() => setTab("salary")}>เงินเดือน</button>
        <button className={tab === "bonus" ? "btn-primary" : ""} onClick={() => setTab("bonus")}>โบนัส</button>
      </div>

      {error && <div className="error-box">{error}</div>}
      {info && <p>{info}</p>}

      {tab === "salary" && (
        <>
          {settingFor && (
            <form onSubmit={submitSalary} style={{ display: "grid", gap: 10, maxWidth: 360, margin: "12px 0" }}>
              <h3>ตั้งเงินเดือน: {settingFor.employee_name}</h3>
              <label>
                เงินเดือน (บาท)
                <input type="number" min="0" step="any" value={salaryAmount} onChange={(e) => setSalaryAmount(e.target.value)} style={{ display: "block" }} />
              </label>
              <label>
                วันที่มีผล
                <input type="date" value={salaryDate} onChange={(e) => setSalaryDate(e.target.value)} style={{ display: "block" }} />
              </label>
              <div style={{ display: "flex", gap: 8 }}>
                <button type="submit" className="btn-primary" disabled={busy}>บันทึก</button>
                <button type="button" onClick={() => setSettingFor(null)}>ยกเลิก</button>
              </div>
            </form>
          )}

          <table style={{ width: "100%", borderCollapse: "collapse" }}>
            <thead>
              <tr style={{ textAlign: "left" }}>
                <th>พนักงาน</th>
                <th>เงินเดือนปัจจุบัน</th>
                <th>วันที่มีผล</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              {salaries.map((s) => (
                <tr key={s.employee_id} style={{ borderTop: "1px solid #ddd" }}>
                  <td>{s.employee_name}</td>
                  <td>{s.amount === null ? "ยังไม่ได้ตั้ง" : money(s.amount)}</td>
                  <td>{dateOnly(s.effective_date)}</td>
                  <td>
                    <button disabled={busy} onClick={() => { setError(""); setSettingFor(s); }}>ตั้งเงินเดือน</button>{" "}
                    <button disabled={busy} onClick={() => showHistory(s)}>ประวัติ</button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
          {salaries.length === 0 && <p>ไม่พบข้อมูลพนักงาน</p>}

          {historyFor && (
            <div style={{ marginTop: 20 }}>
              <h3>ประวัติเงินเดือน: {historyFor.employee_name}</h3>
              {history.length === 0 && <p>ยังไม่มีประวัติ</p>}
              <ul>
                {history.map((h) => (
                  <li key={h.id}>
                    {money(h.amount)} บาท มีผล {dateOnly(h.effective_date)}
                  </li>
                ))}
              </ul>
              <button onClick={() => setHistoryFor(null)}>ปิด</button>
            </div>
          )}
        </>
      )}

      {tab === "bonus" && (
        <>
          <label>
            รอบประเมิน{" "}
            <select value={cycleId} onChange={(e) => { setCycleId(e.target.value); setEditId(null); }}>
              {cycles.map((c) => (
                <option key={c.id} value={c.id}>{c.name}</option>
              ))}
            </select>
          </label>

          <h3 style={{ marginTop: 20 }}>แบบประเมินที่อนุมัติแล้ว และยังไม่มีโบนัส</h3>
          {candidates.length === 0 && <p>ไม่มีรายการ</p>}
          {candidates.map((c) => {
            const evalId = c.evaluation_id ?? c.id ?? 0;
            return (
              <div key={evalId} style={{ margin: "8px 0" }}>
                {c.employee_name ?? nameOf(c.employee_id)}
                {c.total_score !== undefined && <> · คะแนน {c.total_score}</>}{" "}
                <input
                  type="number"
                  min="0"
                  placeholder="ใช้ยอดที่ระบบเสนอ"
                  value={candAmount[evalId] ?? ""}
                  onChange={(e) => setCandAmount({ ...candAmount, [evalId]: e.target.value })}
                  style={{ width: 160 }}
                />{" "}
                <button disabled={busy} onClick={() => createBonus(c)}>สร้างโบนัส</button>
              </div>
            );
          })}

          <h3 style={{ marginTop: 24 }}>โบนัสของรอบนี้</h3>
          <table style={{ width: "100%", borderCollapse: "collapse" }}>
            <thead>
              <tr style={{ textAlign: "left" }}>
                <th>พนักงาน</th>
                <th>เงินเดือน ณ ตอนนั้น</th>
                <th>คะแนน</th>
                <th>ยอดที่ระบบเสนอ</th>
                <th>ยอดที่ยืนยัน</th>
                <th>สถานะ</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              {bonuses.map((b) => (
                <tr key={b.id} style={{ borderTop: "1px solid #ddd" }}>
                  <td>{nameOf(b.employee_id)}</td>
                  <td>{money(b.base_salary)}</td>
                  <td>{b.total_score}</td>
                  <td>{money(b.suggested_amount)}</td>
                  <td>{money(b.amount)}</td>
                  <td>
                    {STATUS_LABEL[b.status]}
                    {b.decision_note && <div><small>{b.decision_note}</small></div>}
                  </td>
                  <td>
                    {b.status === "pending_approval" && (
                      <button disabled={busy} onClick={() => startEdit(b)}>แก้ยอด</button>
                    )}
                    {editId === b.id && (
                      <div style={{ marginTop: 6, display: "grid", gap: 6 }}>
                        <input type="number" min="0" value={editAmount} onChange={(e) => setEditAmount(e.target.value)} />
                        <input placeholder="หมายเหตุ" value={editNote} onChange={(e) => setEditNote(e.target.value)} />
                        <div>
                          <button disabled={busy} onClick={saveEdit}>บันทึก</button>{" "}
                          <button onClick={() => setEditId(null)}>ยกเลิก</button>
                        </div>
                      </div>
                    )}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
          {bonuses.length === 0 && <p>ยังไม่มีโบนัสในรอบนี้</p>}
        </>
      )}
    </div>
  );
}