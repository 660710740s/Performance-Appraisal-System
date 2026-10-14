import "../redesign.css";
import { useCallback, useEffect, useState } from "react";
import client, { errorMessage } from "../api/client";
import type { Cycle } from "../types";

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

interface Candidate {
  evaluation_id: number;
  employee_id: number;
  total_score: number;
  base_salary: number | null;
  suggested_amount: number | null;
  eligible: boolean; // NEW: ผ่านเกณฑ์และเสนอได้
  reason?: string; // NEW: เหตุผลที่เสนอไม่ได้
}

// NEW: ผลการเสนอแบบกลุ่มจาก backend
interface BulkCreateResult {
  created: number;
  total_amount: number;
  skipped: { evaluation_id: number; employee_id: number; reason: string }[];
}

const STATUS_LABEL = {
  pending_approval: "รอผู้บริหารอนุมัติ",
  approved: "อนุมัติแล้ว",
  rejected: "ไม่อนุมัติ",
};

const money = (n: number | null | undefined) =>
  n === null || n === undefined ? "-" : n.toLocaleString("th-TH");

export default function HRBonusPage() {
  const [cycles, setCycles] = useState<Cycle[]>([]);
  const [cycleId, setCycleId] = useState("");
  const [names, setNames] = useState<Record<number, string>>({});
  const [candidates, setCandidates] = useState<Candidate[]>([]);
  const [bonuses, setBonuses] = useState<Bonus[]>([]);
  const [candAmount, setCandAmount] = useState<Record<number, string>>({});
  const [editId, setEditId] = useState<number | null>(null);
  const [editAmount, setEditAmount] = useState("");
  const [editNote, setEditNote] = useState("");
  const [error, setError] = useState("");
  const [info, setInfo] = useState("");
  const [busy, setBusy] = useState(false);
  // NEW: คะแนนขั้นต่ำ (ไม่บังคับ) และผลการเสนอแบบกลุ่ม
  const [minInput, setMinInput] = useState("");
  const [appliedMin, setAppliedMin] = useState<number | null>(null);
  const [bulkResult, setBulkResult] = useState<BulkCreateResult | null>(null);

  const nameOf = (id: number) => names[id] ?? `#${id}`;

  useEffect(() => {
    client
      .get("/cycles")
      .then((res) => {
        const list: Cycle[] = res.data.data ?? [];
        setCycles(list);
        if (list.length > 0) setCycleId(String(list[0].id));
      })
      .catch((err) => setError(errorMessage(err)));

    // ปรับ field ตามที่ /users ส่งกลับจริง (สมมติว่ามี id กับ name)
    client
      .get("/users")
      .then((res) => {
        const map: Record<number, string> = {};
        (res.data.data ?? []).forEach((u: { id: number; name: string }) => {
          map[u.id] = u.name;
        });
        setNames(map);
      })
      .catch(() => {});
  }, []);

  const load = useCallback(async () => {
    if (!cycleId) return;
    try {
      const [c, b] = await Promise.all([
        client.get("/accounting/bonus-candidates", {
          params: { cycle_id: cycleId, ...(appliedMin !== null ? { min_score: appliedMin } : {}) },
        }),
        client.get("/accounting/bonuses", { params: { cycle_id: cycleId } }),
      ]);
      setCandidates(c.data.data ?? []);
      setBonuses(b.data.data ?? []);
    } catch (err) {
      setError(errorMessage(err));
    }
  }, [cycleId, appliedMin]);

  useEffect(() => {
    load();
  }, [load]);

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

  function createBonus(c: Candidate) {
    const raw = candAmount[c.evaluation_id];
    const body: Record<string, unknown> = { evaluation_id: c.evaluation_id };
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
      await load();
    }, "เสนอโบนัสแล้ว ส่งให้ผู้บริหารอนุมัติ");
  }

  // NEW: ใช้คะแนนขั้นต่ำที่กรอก (ว่าง = ใช้เกณฑ์ปกติของระบบ)
  function applyMin() {
    const t = minInput.trim();
    if (t === "") {
      setAppliedMin(null);
      return;
    }
    const n = Number(t);
    if (Number.isNaN(n) || n < 1 || n > 5) {
      setError("คะแนนขั้นต่ำต้องอยู่ระหว่าง 1 ถึง 5");
      return;
    }
    setError("");
    setAppliedMin(n);
  }

  const eligible = candidates.filter((c) => c.eligible);
  const notEligible = candidates.filter((c) => !c.eligible);
  const eligibleTotal = eligible.reduce((sum, c) => sum + (c.suggested_amount ?? 0), 0);

  // NEW: เสนอทุกคนที่ผ่านเกณฑ์ด้วยยอดที่ระบบเสนอ ในการกดครั้งเดียว
  async function createAllEligible() {
    if (eligible.length === 0) return;
    const ok = window.confirm(
      `เสนอโบนัสให้ ${eligible.length} คน ยอดรวม ${money(eligibleTotal)} บาท ใช่หรือไม่?`
    );
    if (!ok) return;
    setError("");
    setInfo("");
    setBulkResult(null);
    setBusy(true);
    try {
      const body: Record<string, unknown> = { cycle_id: Number(cycleId) };
      if (appliedMin !== null) body.min_score = appliedMin;
      const res = await client.post("/accounting/bonuses/bulk", body);
      const r: BulkCreateResult = res.data.data;
      setBulkResult(r);
      setInfo(`เสนอโบนัสแล้ว ${r.created} คน ยอดรวม ${money(r.total_amount)} บาท ส่งให้ผู้บริหารอนุมัติ`);
      await load();
    } catch (err) {
      setError(errorMessage(err));
    } finally {
      setBusy(false);
    }
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
      await load();
    }, "แก้ยอดและส่งให้ผู้บริหารอนุมัติใหม่แล้ว");
  }

  return (
    <div style={{ maxWidth: 1000 }}>
      <h1>เสนอโบนัส</h1>

      {error && <div className="error-box">{error}</div>}
      {info && <p>{info}</p>}

      <label>
        รอบประเมิน{" "}
        <select
          value={cycleId}
          onChange={(e) => {
            setCycleId(e.target.value);
            setEditId(null);
            setBulkResult(null);
          }}
        >
          {cycles.map((c) => (
            <option key={c.id} value={c.id}>{c.name}</option>
          ))}
        </select>
      </label>

      <h3 style={{ marginTop: 20 }}>แบบประเมินที่อนุมัติแล้ว และยังไม่ได้เสนอโบนัส</h3>

      <label>
        คะแนนขั้นต่ำ (ไม่บังคับ){" "}
        <input
          type="number"
          min="1"
          max="5"
          step="0.1"
          placeholder="เช่น 3"
          value={minInput}
          onChange={(e) => setMinInput(e.target.value)}
          onBlur={applyMin}
          onKeyDown={(e) => {
            if (e.key === "Enter") applyMin();
          }}
          style={{ width: 100 }}
        />
      </label>

      {candidates.length === 0 && <p>ไม่มีรายการ</p>}
      {candidates.length > 0 && (
        <p>
          ผ่านเกณฑ์ {eligible.length} คน · ยอดรวมที่ระบบเสนอ {money(eligibleTotal)} บาท · ยังเสนอไม่ได้{" "}
          {notEligible.length} คน
        </p>
      )}
      <button disabled={busy || eligible.length === 0} onClick={createAllEligible}>
        เสนอทั้งหมดที่ผ่านเกณฑ์ ({eligible.length} คน)
      </button>

      {bulkResult && bulkResult.skipped.length > 0 && (
        <details style={{ marginTop: 8 }}>
          <summary>ข้ามไป {bulkResult.skipped.length} คน</summary>
          {bulkResult.skipped.map((s) => (
            <div key={s.evaluation_id}>
              {nameOf(s.employee_id)} · {s.reason}
            </div>
          ))}
        </details>
      )}

      <h4 style={{ marginTop: 16 }}>ปรับยอดหรือเสนอรายคน</h4>
      {eligible.length === 0 && <p>ไม่มีรายการที่ผ่านเกณฑ์</p>}
      {eligible.map((c) => (
        <div key={c.evaluation_id} style={{ margin: "8px 0" }}>
          {nameOf(c.employee_id)} · คะแนน {c.total_score} · เงินเดือน {money(c.base_salary)} · ระบบเสนอ{" "}
          {money(c.suggested_amount)}{" "}
          <input
            type="number"
            min="0"
            placeholder="ใช้ยอดที่ระบบเสนอ"
            value={candAmount[c.evaluation_id] ?? ""}
            onChange={(e) => setCandAmount({ ...candAmount, [c.evaluation_id]: e.target.value })}
            style={{ width: 160 }}
          />{" "}
          <button disabled={busy || c.suggested_amount === null} onClick={() => createBonus(c)}>
            เสนอโบนัส
          </button>
        </div>
      ))}

      {notEligible.length > 0 && (
        <details style={{ marginTop: 12 }}>
          <summary>ยังเสนอไม่ได้ {notEligible.length} คน</summary>
          {notEligible.map((c) => (
            <div key={c.evaluation_id} style={{ margin: "6px 0" }}>
              {nameOf(c.employee_id)} · คะแนน {c.total_score} · {c.reason ?? "เสนอไม่ได้"}
            </div>
          ))}
        </details>
      )}

      <h3 style={{ marginTop: 24 }}>ข้อเสนอโบนัสของรอบนี้</h3>
      <table style={{ width: "100%", borderCollapse: "collapse" }}>
        <thead>
          <tr style={{ textAlign: "left" }}>
            <th>พนักงาน</th>
            <th>เงินเดือน ณ สิ้นรอบ</th>
            <th>คะแนน</th>
            <th>ยอดที่ระบบเสนอ</th>
            <th>ยอดที่เสนอ</th>
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
                {b.status !== "approved" && (
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
      {bonuses.length === 0 && <p>ยังไม่มีข้อเสนอโบนัสในรอบนี้</p>}
    </div>
  );
}
