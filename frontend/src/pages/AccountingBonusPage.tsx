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
  status: "pending_approval" | "approved" | "rejected" | "paid";
  paid_at: string | null;
  paid_by: number | null;
  payment_note: string;
  note: string;
  decision_note: string;
}

// รูปแบบของ bonus-candidates ยังไม่ได้ตรวจกับ backend จึงรับแบบยืดหยุ่น
const STATUS_LABEL: Record<Bonus["status"], string> = {
  pending_approval: "รอผู้บริหารอนุมัติ",
  approved: "อนุมัติแล้ว / รอจ่าย",
  rejected: "ไม่อนุมัติ",
  paid: "จ่ายแล้ว",
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
  const [bonuses, setBonuses] = useState<Bonus[]>([]);
  const [paymentNote, setPaymentNote] = useState<Record<number, string>>({});

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
      const b = await client.get("/accounting/bonuses", {
        params: { cycle_id: cycleId },
      });
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

  function payBonus(b: Bonus) {
    if (!window.confirm(
      `ยืนยันบันทึกการจ่ายโบนัสให้ ${nameOf(b.employee_id)} จำนวน ${money(b.amount)} บาท?`
    )) return;

    run(async () => {
      await client.post(`/accounting/bonuses/${b.id}/pay`, {
        note: paymentNote[b.id] ?? "",
      });
      await loadBonus();
    }, "บันทึกการจ่ายโบนัสเรียบร้อยแล้ว");
  }

  const approvedBonuses = bonuses.filter((b) => b.status === "approved");
  const paidBonuses = bonuses.filter((b) => b.status === "paid");

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
            <select
              value={cycleId}
              onChange={(e) => setCycleId(e.target.value)}
            >
              {cycles.map((c) => (
                <option key={c.id} value={c.id}>{c.name}</option>
              ))}
            </select>
          </label>

          <h3 style={{ marginTop: 24 }}>
            รอจ่ายโบนัส ({approvedBonuses.length} รายการ)
          </h3>
          <p>แสดงเฉพาะโบนัสที่ผู้บริหารอนุมัติแล้ว</p>

          <table style={{ width: "100%", borderCollapse: "collapse" }}>
            <thead>
              <tr style={{ textAlign: "left" }}>
                <th>พนักงาน</th>
                <th>คะแนน KPI</th>
                <th>เงินเดือนฐาน</th>
                <th>ยอดโบนัส</th>
                <th>บันทึกการจ่าย</th>
              </tr>
            </thead>
            <tbody>
              {approvedBonuses.map((b) => (
                <tr key={b.id} style={{ borderTop: "1px solid #ddd" }}>
                  <td>{nameOf(b.employee_id)}</td>
                  <td>{b.total_score}</td>
                  <td>{money(b.base_salary)} บาท</td>
                  <td>{money(b.amount)} บาท</td>
                  <td>
                    <input
                      placeholder="หมายเหตุการจ่าย (ไม่บังคับ)"
                      value={paymentNote[b.id] ?? ""}
                      onChange={(e) =>
                        setPaymentNote((prev) => ({
                          ...prev,
                          [b.id]: e.target.value,
                        }))
                      }
                    />
                    {" "}
                    <button
                      className="btn-primary"
                      disabled={busy}
                      onClick={() => payBonus(b)}
                    >
                      ยืนยันการจ่าย
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>

          {approvedBonuses.length === 0 && (
            <p>ไม่มีโบนัสที่รอจ่ายในรอบนี้</p>
          )}

          <h3 style={{ marginTop: 32 }}>
            ประวัติการจ่ายโบนัส ({paidBonuses.length} รายการ)
          </h3>

          <table style={{ width: "100%", borderCollapse: "collapse" }}>
            <thead>
              <tr style={{ textAlign: "left" }}>
                <th>พนักงาน</th>
                <th>ยอดโบนัส</th>
                <th>วันที่บันทึกจ่าย</th>
                <th>ผู้บันทึก (ID)</th>
                <th>หมายเหตุ</th>
                <th>สถานะ</th>
              </tr>
            </thead>
            <tbody>
              {paidBonuses.map((b) => (
                <tr key={b.id} style={{ borderTop: "1px solid #ddd" }}>
                  <td>{nameOf(b.employee_id)}</td>
                  <td>{money(b.amount)} บาท</td>
                  <td>{b.paid_at ? new Date(b.paid_at).toLocaleString("th-TH") : "-"}</td>
                  <td>{b.paid_by ?? "-"}</td>
                  <td>{b.payment_note || "-"}</td>
                  <td>{STATUS_LABEL[b.status]}</td>
                </tr>
              ))}
            </tbody>
          </table>

          {paidBonuses.length === 0 && (
            <p>ยังไม่มีประวัติการจ่ายโบนัสในรอบนี้</p>
          )}
        </>
      )}
    </div>
  );
}
