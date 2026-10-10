import "../redesign.css";
import { useCallback, useEffect, useState, type FormEvent } from "react";
import client, { errorMessage } from "../api/client";
import type { Department, Level, Position, User } from "../types";

type Decision = "pending_approval" | "approved" | "rejected";

interface EvalRow {
  id: number;
  cycle_name: string;
  employee_id: number;
  employee_name: string;
  total_score?: number;
}
interface Promotion {
  id: number;
  employee_id: number;
  from_position: string;
  to_position: string;
  from_level: string;
  to_level: string;
  status: Decision;
  note: string;
  decision_note: string;
}
interface Transfer {
  id: number;
  employee_id: number;
  from_department: string;
  to_department: string;
  effective_date: string | null;
  status: Decision;
  note: string;
  decision_note: string;
}

const DECISION_LABEL: Record<Decision, string> = {
  pending_approval: "รอผู้บริหารอนุมัติ",
  approved: "อนุมัติแล้ว",
  rejected: "ไม่อนุมัติ",
};
const dateOnly = (iso: string | null) => (iso && !iso.startsWith("0001") ? iso.slice(0, 10) : "-");

export default function HRProposalsPage() {
  const [tab, setTab] = useState<"promotion" | "transfer">("promotion");
  const [evals, setEvals] = useState<EvalRow[]>([]);
  const [users, setUsers] = useState<User[]>([]);
  const [departments, setDepartments] = useState<Department[]>([]);
  const [levels, setLevels] = useState<Level[]>([]);
  const [positions, setPositions] = useState<Position[]>([]);
  const [promotions, setPromotions] = useState<Promotion[]>([]);
  const [transfers, setTransfers] = useState<Transfer[]>([]);
  const [evaluationId, setEvaluationId] = useState("");
  const [toPosition, setToPosition] = useState("");
  const [toLevel, setToLevel] = useState("");
  const [toDepartment, setToDepartment] = useState("");
  const [effectiveDate, setEffectiveDate] = useState("");
  const [note, setNote] = useState("");
  const [error, setError] = useState("");
  const [info, setInfo] = useState("");
  const [busy, setBusy] = useState(false);

  const load = useCallback(async () => {
  try {
    const [p, t, e, u, d, l, pos] = await Promise.all([   // ← เพิ่ม pos
      client.get("/hr/promotions"),
      client.get("/hr/transfers"),
      client.get("/reports/evaluations", { params: { status: "approved", type: "supervisor", limit: 500 } }),
      client.get("/users"),
      client.get("/departments"),
      client.get("/levels"),
      client.get("/positions"),                           // ← เพิ่มบรรทัดนี้
    ]);
    setPromotions(p.data.data ?? []);
    setTransfers(t.data.data ?? []);
    setEvals(e.data.data ?? []);
    setUsers(u.data.data ?? []);
    setDepartments(d.data.data ?? []);
    setLevels(l.data.data ?? []);
    setPositions(pos.data.data ?? []);
  } catch (err) {
    setError(errorMessage(err));
  }
}, []);

  useEffect(() => {
    load();
  }, [load]);

  const nameOf = (id: number) => users.find((u) => u.id === id)?.name ?? `#${id}`;

  function resetForm() {
    setEvaluationId("");
    setToPosition("");
    setToLevel("");
    setToDepartment("");
    setEffectiveDate("");
    setNote("");
  }

  async function submit(e: FormEvent) {
    e.preventDefault();
    setError("");
    setInfo("");
    if (!evaluationId) {
      setError("กรุณาเลือกแบบประเมิน");
      return;
    }
    const body: Record<string, unknown> = { evaluation_id: Number(evaluationId), note };
    if (tab === "promotion") {
      if (!toPosition.trim()) {
        setError("กรุณากรอกตำแหน่งที่เสนอ");
        return;
      }
      body.to_position = toPosition.trim();
      if (toLevel.trim()) body.to_level = toLevel.trim();
    } else {
      if (!toDepartment.trim()) {
        setError("กรุณากรอกแผนกปลายทาง");
        return;
      }
      body.to_department = toDepartment.trim();
      if (effectiveDate) body.effective_date = `${effectiveDate}T00:00:00Z`;
    }
    setBusy(true);
    try {
      await client.post(tab === "promotion" ? "/hr/promotions" : "/hr/transfers", body);
      setInfo("ส่งข้อเสนอให้ผู้บริหารแล้ว");
      resetForm();
      await load();
    } catch (err) {
      setError(errorMessage(err));
    } finally {
      setBusy(false);
    }
  }

  return (
    <div style={{ maxWidth: 1000 }}>
      <h1>เสนอเลื่อนตำแหน่ง / โอนย้าย</h1>
      <div style={{ display: "flex", gap: 8, margin: "12px 0" }}>
        <button className={tab === "promotion" ? "btn-primary" : ""} style={{ width: "auto" }} onClick={() => { setTab("promotion"); setError(""); setInfo(""); }}>
          เลื่อนตำแหน่ง
        </button>
        <button className={tab === "transfer" ? "btn-primary" : ""} style={{ width: "auto" }} onClick={() => { setTab("transfer"); setError(""); setInfo(""); }}>
          โอนย้ายแผนก
        </button>
      </div>

      <form onSubmit={submit} style={{ display: "grid", gap: 10, maxWidth: 480, margin: "16px 0" }}>
        <h3>{tab === "promotion" ? "เสนอเลื่อนตำแหน่ง" : "เสนอโอนย้ายแผนก"}</h3>
        <label>
          แบบประเมิน (หัวหน้าประเมินและอนุมัติแล้ว)
          <select value={evaluationId} onChange={(e) => setEvaluationId(e.target.value)} style={{ display: "block", width: "100%" }}>
            <option value="">-- เลือก --</option>
            {evals.map((r) => (
              <option key={r.id} value={r.id}>
                {r.employee_name} · {r.cycle_name} · คะแนน {r.total_score ?? "-"}
              </option>
            ))}
          </select>
        </label>
        {tab === "promotion" ? (
          <>
          <label>
  ตำแหน่งที่เสนอ
  <select value={toPosition} onChange={(e) => setToPosition(e.target.value)} style={{ display: "block", width: "100%" }}>
    <option value="">-- เลือก --</option>
    {positions.map((p) => (
      <option key={p.id} value={p.name}>{p.name}</option>
    ))}
  </select>
</label>
            <label>
              ระดับที่เสนอ (ไม่บังคับ)
              <select value={toLevel} onChange={(e) => setToLevel(e.target.value)} style={{ display: "block", width: "100%" }}>
                <option value="">ไม่ระบุ</option>
                {levels.map((l) => (
                  <option key={l.id} value={l.name}>{l.name}</option>
                ))}
              </select>
            </label>
          </>
        ) : (
          <>
            <label>
              แผนกปลายทาง
              <select value={toDepartment} onChange={(e) => setToDepartment(e.target.value)} style={{ display: "block", width: "100%" }}>
                <option value="">-- เลือก --</option>
                {departments.map((d) => (
                  <option key={d.id} value={d.name}>{d.name}</option>
                ))}
              </select>
            </label>
          </>
        )}
        <label>
          หมายเหตุ
          <input value={note} onChange={(e) => setNote(e.target.value)} style={{ display: "block", width: "100%" }} />
        </label>
        <div>
          <button type="submit" className="btn-primary" style={{ width: "auto" }} disabled={busy}>
            ส่งข้อเสนอ
          </button>
        </div>
      </form>

      {error && <div className="error-box">{error}</div>}
      {info && <p>{info}</p>}

      {tab === "promotion" ? (
        <>
          <table style={{ width: "100%", borderCollapse: "collapse" }}>
            <thead>
              <tr style={{ textAlign: "left" }}>
                <th>พนักงาน</th>
                <th>จาก</th>
                <th>เป็น</th>
                <th>สถานะ</th>
              </tr>
            </thead>
            <tbody>
              {promotions.map((p) => (
                <tr key={p.id} style={{ borderTop: "1px solid #ddd" }}>
                  <td>{nameOf(p.employee_id)}</td>
                  <td>{p.from_position || "-"} ({p.from_level || "-"})</td>
                  <td>{p.to_position} ({p.to_level || "-"})</td>
                  <td>
                    {DECISION_LABEL[p.status]}
                    {p.decision_note && <div><small>{p.decision_note}</small></div>}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
          {promotions.length === 0 && <p>ยังไม่มีข้อเสนอเลื่อนตำแหน่ง</p>}
        </>
      ) : (
        <>
          <table style={{ width: "100%", borderCollapse: "collapse" }}>
            <thead>
              <tr style={{ textAlign: "left" }}>
                <th>พนักงาน</th>
                <th>จากแผนก</th>
                <th>ไปแผนก</th>
                <th>วันที่มีผล</th>
                <th>สถานะ</th>
              </tr>
            </thead>
            <tbody>
              {transfers.map((t) => (
                <tr key={t.id} style={{ borderTop: "1px solid #ddd" }}>
                  <td>{nameOf(t.employee_id)}</td>
                  <td>{t.from_department || "-"}</td>
                  <td>{t.to_department}</td>
                  <td>{dateOnly(t.effective_date)}</td>
                  <td>
                    {DECISION_LABEL[t.status]}
                    {t.decision_note && <div><small>{t.decision_note}</small></div>}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
          {transfers.length === 0 && <p>ยังไม่มีข้อเสนอโอนย้าย</p>}
        </>
      )}
    </div>
  );
}