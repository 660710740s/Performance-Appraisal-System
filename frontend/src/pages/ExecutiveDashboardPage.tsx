import "../redesign.css";
import { useCallback, useEffect, useState } from "react";
import client, { errorMessage } from "../api/client";
import type { Cycle } from "../types";

interface Bonus {
  id: number;
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

interface Summary {
  departments: { department: string; employee_count: number; avg_score: number }[];
  progress: { cycle_id: number; cycle_name: string; total_people: number; approved: number }[];
  bonuses: { status: string; count: number; total_amount: number }[];
}

const STATUS_LABEL = {
  pending_approval: "รออนุมัติ",
  approved: "อนุมัติแล้ว",
  rejected: "ไม่อนุมัติ",
};

const money = (n: number) => n.toLocaleString("th-TH");

export default function ExecutiveDashboardPage() {
  const [summary, setSummary] = useState<Summary | null>(null);
  const [bonuses, setBonuses] = useState<Bonus[]>([]);
  const [cycles, setCycles] = useState<Cycle[]>([]);
  const [cycleId, setCycleId] = useState("");
  const [status, setStatus] = useState("pending_approval");
  const [noteFor, setNoteFor] = useState<number | null>(null);
  const [note, setNote] = useState("");
  const [error, setError] = useState("");
  const [info, setInfo] = useState("");
  const [busy, setBusy] = useState(false);

  const loadSummary = useCallback(async () => {
    try {
      const res = await client.get("/reports/summary");
      setSummary(res.data.data);
    } catch (err) {
      setError(errorMessage(err));
    }
  }, []);

  useEffect(() => {
    loadSummary();
    client
      .get("/cycles")
      .then((res) => setCycles(res.data.data ?? []))
      .catch((err) => setError(errorMessage(err)));
  }, [loadSummary]);

  const load = useCallback(async () => {
    try {
      const params: Record<string, string> = {};
      if (cycleId) params.cycle_id = cycleId;
      if (status) params.status = status;
      const res = await client.get("/executive/bonuses", { params });
      setBonuses(res.data.data ?? []);
    } catch (err) {
      setError(errorMessage(err));
    }
  }, [cycleId, status]);

  useEffect(() => {
    load();
  }, [load]);

  const cycleName = (id: number) => cycles.find((c) => c.id === id)?.name ?? `รอบ #${id}`;
  const pendingCount = summary?.bonuses?.find((b) => b.status === "pending_approval")?.count ?? 0;

  async function decide(id: number, action: "approve" | "reject") {
    setError("");
    setInfo("");
    setBusy(true);
    try {
      await client.post(`/executive/bonuses/${id}/${action}`, { note });
      setInfo(action === "approve" ? "อนุมัติโบนัสแล้ว" : "ไม่อนุมัติโบนัสแล้ว");
      setNoteFor(null);
      setNote("");
      await Promise.all([load(), loadSummary()]);
    } catch (err) {
      setError(errorMessage(err));
    } finally {
      setBusy(false);
    }
  }

  return (
    <div style={{ maxWidth: 1000 }}>
      <h1>แดชบอร์ดผู้บริหาร</h1>
      {error && <div className="error-box">{error}</div>}

      {summary && (
        <section>
          <p>โบนัสรออนุมัติ: <strong>{pendingCount}</strong> รายการ</p>

          <h3>คะแนนเฉลี่ยตามแผนก</h3>
          {(summary.departments ?? []).length === 0 && <p>ยังไม่มีข้อมูล</p>}
          <ul>
            {(summary.departments ?? []).map((d) => (
              <li key={d.department}>
                {d.department}: {d.avg_score.toFixed(2)} ({d.employee_count} คน)
              </li>
            ))}
          </ul>

          <h3>ความคืบหน้าแต่ละรอบ</h3>
          <ul>
            {(summary.progress ?? []).map((p) => (
              <li key={p.cycle_id}>
                {p.cycle_name}: อนุมัติแล้ว {p.approved} จาก {p.total_people} คน
              </li>
            ))}
          </ul>
        </section>
      )}

      <h2>อนุมัติโบนัส</h2>
      <div style={{ display: "flex", gap: 12, margin: "12px 0" }}>
        <select value={cycleId} onChange={(e) => setCycleId(e.target.value)}>
          <option value="">ทุกรอบ</option>
          {cycles.map((c) => (
            <option key={c.id} value={c.id}>{c.name}</option>
          ))}
        </select>
        <select value={status} onChange={(e) => setStatus(e.target.value)}>
          <option value="pending_approval">รออนุมัติ</option>
          <option value="approved">อนุมัติแล้ว</option>
          <option value="rejected">ไม่อนุมัติ</option>
          <option value="">ทุกสถานะ</option>
        </select>
      </div>

      {info && <p>{info}</p>}

      <table style={{ width: "100%", borderCollapse: "collapse" }}>
        <thead>
          <tr style={{ textAlign: "left" }}>
            <th>รอบ</th>
            <th>พนักงาน</th>
            <th>เงินเดือน</th>
            <th>คะแนน</th>
            <th>ระบบเสนอ</th>
            <th>ยอดที่ขออนุมัติ</th>
            <th>สถานะ</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          {bonuses.map((b) => (
            <tr key={b.id} style={{ borderTop: "1px solid #ddd" }}>
              <td>{cycleName(b.cycle_id)}</td>
              <td>พนักงาน #{b.employee_id}</td>
              <td>{money(b.base_salary)}</td>
              <td>{b.total_score}</td>
              <td>{money(b.suggested_amount)}</td>
              <td>
                {money(b.amount)}
                {b.note && <div><small>หมายเหตุบัญชี: {b.note}</small></div>}
              </td>
              <td>
                {STATUS_LABEL[b.status]}
                {b.decision_note && <div><small>{b.decision_note}</small></div>}
              </td>
              <td>
                {b.status === "pending_approval" && noteFor !== b.id && (
                  <button disabled={busy} onClick={() => { setNoteFor(b.id); setNote(""); }}>พิจารณา</button>
                )}
                {noteFor === b.id && (
                  <div style={{ display: "grid", gap: 6 }}>
                    <input placeholder="หมายเหตุ (ไม่บังคับ)" value={note} onChange={(e) => setNote(e.target.value)} />
                    <div>
                      <button disabled={busy} className="btn-primary" onClick={() => decide(b.id, "approve")}>อนุมัติ</button>{" "}
                      <button disabled={busy} onClick={() => decide(b.id, "reject")}>ไม่อนุมัติ</button>{" "}
                      <button onClick={() => setNoteFor(null)}>ยกเลิก</button>
                    </div>
                  </div>
                )}
              </td>
            </tr>
          ))}
        </tbody>
      </table>
      {bonuses.length === 0 && <p>ไม่มีรายการตามเงื่อนไขที่เลือก</p>}
    </div>
  );
}