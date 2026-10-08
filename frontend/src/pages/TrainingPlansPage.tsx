import { useCallback, useEffect, useState, type FormEvent } from "react";
import client, { errorMessage } from "../api/client";
import { useAuth } from "../context/AuthContext";

type PlanStatus = "planned" | "in_progress" | "completed" | "cancelled";

interface Plan {
  id: number;
  evaluation_id: number;
  employee_id: number;
  topic: string;
  reason: string;
  start_date: string | null;
  end_date: string | null;
  status: PlanStatus;
}
interface EvalOpt {
  id: number;
  employee_id: number;
  employee_name: string;
  cycle_name: string;
}
interface HistoryItem {
  id: number;
  cycle_name: string;
  type: "self" | "supervisor";
  status: string;
}

const STATUS_LABEL: Record<PlanStatus, string> = {
  planned: "วางแผนไว้",
  in_progress: "กำลังดำเนินการ",
  completed: "เสร็จสิ้น",
  cancelled: "ยกเลิก",
};
const NEXT: Record<PlanStatus, PlanStatus[]> = {
  planned: ["in_progress", "cancelled"],
  in_progress: ["completed", "cancelled"],
  completed: [],
  cancelled: [],
};
const validDate = (iso: string | null) => (iso && !iso.startsWith("0001") ? iso.slice(0, 10) : "");

export default function TrainingPlansPage() {
  const { user } = useAuth();
  const canManage = user?.role === "manager" || user?.role === "hr";
  const [plans, setPlans] = useState<Plan[]>([]);
  const [opts, setOpts] = useState<EvalOpt[]>([]);
  const [editingId, setEditingId] = useState<number | null>(null);
  const [evaluationId, setEvaluationId] = useState("");
  const [topic, setTopic] = useState("");
  const [reason, setReason] = useState("");
  const [startDate, setStartDate] = useState("");
  const [endDate, setEndDate] = useState("");
  const [error, setError] = useState("");
  const [info, setInfo] = useState("");
  const [busy, setBusy] = useState(false);

  const loadPlans = useCallback(async () => {
    try {
      const res = await client.get("/training-plans");
      setPlans(res.data.data ?? []);
    } catch (err) {
      setError(errorMessage(err));
    }
  }, []);

  useEffect(() => {
    loadPlans();
  }, [loadPlans]);

  // รายการแบบประเมินที่เลือกได้ (เฉพาะ manager และ hr)
  useEffect(() => {
    async function loadOpts() {
      try {
        if (user?.role === "hr") {
          const res = await client.get("/reports/evaluations", {
            params: { status: "approved", type: "supervisor", limit: 500 },
          });
          setOpts(
            (res.data.data ?? []).map((r: EvalOpt) => ({
              id: r.id,
              employee_id: r.employee_id,
              employee_name: r.employee_name,
              cycle_name: r.cycle_name,
            }))
          );
        } else if (user?.role === "manager") {
          const t = await client.get("/team");
          const members: { id: number; name: string }[] = t.data.data ?? [];
          const lists = await Promise.all(
            members.map(async (m) => {
              const res = await client.get(`/employees/${m.id}/evaluations`);
              const items: HistoryItem[] = res.data.data ?? [];
              return items
                .filter((h) => h.type === "supervisor" && h.status === "approved")
                .map((h) => ({ id: h.id, employee_id: m.id, employee_name: m.name, cycle_name: h.cycle_name }));
            })
          );
          setOpts(lists.flat());
        }
      } catch (err) {
        setError(errorMessage(err));
      }
    }
    loadOpts();
  }, [user?.role]);

    const nameOf = (id: number) =>
    id === user?.id
      ? user.name
      : opts.find((o) => o.employee_id === id)?.employee_name ?? `พนักงาน #${id}`;

  function resetForm() {
    setEditingId(null);
    setEvaluationId("");
    setTopic("");
    setReason("");
    setStartDate("");
    setEndDate("");
  }

  function startEdit(p: Plan) {
    setError("");
    setInfo("");
    setEditingId(p.id);
    setTopic(p.topic);
    setReason(p.reason ?? "");
    setStartDate(validDate(p.start_date));
    setEndDate(validDate(p.end_date));
  }

  async function submit(e: FormEvent) {
    e.preventDefault();
    setError("");
    setInfo("");
    if (!topic.trim()) {
      setError("กรุณากรอกหัวข้อการฝึกอบรม");
      return;
    }
    if (!editingId && !evaluationId) {
      setError("กรุณาเลือกแบบประเมิน");
      return;
    }
    if (startDate && endDate && endDate < startDate) {
      setError("วันสิ้นสุดต้องไม่ก่อนวันเริ่ม");
      return;
    }
    const body: Record<string, unknown> = { topic: topic.trim(), reason };
    if (startDate) body.start_date = `${startDate}T00:00:00Z`;
    if (endDate) body.end_date = `${endDate}T00:00:00Z`;
    setBusy(true);
    try {
      if (editingId) {
        await client.put(`/training-plans/${editingId}`, body);
        setInfo("แก้ไขแผนแล้ว");
      } else {
        await client.post("/training-plans", { ...body, evaluation_id: Number(evaluationId) });
        setInfo("สร้างแผนฝึกอบรมแล้ว");
      }
      resetForm();
      await loadPlans();
    } catch (err) {
      setError(errorMessage(err));
    } finally {
      setBusy(false);
    }
  }

  async function changeStatus(p: Plan, status: PlanStatus) {
    setError("");
    setInfo("");
    setBusy(true);
    try {
      await client.patch(`/training-plans/${p.id}/status`, { status });
      setInfo("เปลี่ยนสถานะแล้ว");
      await loadPlans();
    } catch (err) {
      setError(errorMessage(err));
    } finally {
      setBusy(false);
    }
  }

  return (
    <div style={{ maxWidth: 1000 }}>
      <h1>แผนฝึกอบรม</h1>

      {canManage && (
        <form onSubmit={submit} style={{ display: "grid", gap: 10, maxWidth: 480, margin: "16px 0" }}>
          <h3>{editingId ? "แก้ไขแผน" : "สร้างแผนฝึกอบรม"}</h3>
          {!editingId && (
            <label>
              แบบประเมิน (หัวหน้าประเมินและอนุมัติแล้ว)
              <select value={evaluationId} onChange={(e) => setEvaluationId(e.target.value)} style={{ display: "block", width: "100%" }}>
                <option value="">-- เลือก --</option>
                {opts.map((o) => (
                  <option key={o.id} value={o.id}>
                    {o.employee_name} · {o.cycle_name}
                  </option>
                ))}
              </select>
            </label>
          )}
          <label>
            หัวข้อ
            <input value={topic} onChange={(e) => setTopic(e.target.value)} style={{ display: "block", width: "100%" }} />
          </label>
          <label>
            เหตุผล
            <textarea value={reason} onChange={(e) => setReason(e.target.value)} rows={2} style={{ display: "block", width: "100%" }} />
          </label>
          <label>
            วันเริ่ม
            <input type="date" value={startDate} onChange={(e) => setStartDate(e.target.value)} style={{ display: "block" }} />
          </label>
          <label>
            วันสิ้นสุด
            <input type="date" value={endDate} onChange={(e) => setEndDate(e.target.value)} style={{ display: "block" }} />
          </label>
          <div style={{ display: "flex", gap: 8 }}>
            <button type="submit" className="btn-primary" style={{ width: "auto" }} disabled={busy}>
              {editingId ? "บันทึกการแก้ไข" : "สร้างแผน"}
            </button>
            {editingId && <button type="button" onClick={resetForm}>ยกเลิก</button>}
          </div>
        </form>
      )}

      {error && <div className="error-box">{error}</div>}
      {info && <p>{info}</p>}

      <table style={{ width: "100%", borderCollapse: "collapse" }}>
        <thead>
          <tr style={{ textAlign: "left" }}>
            <th>พนักงาน</th>
            <th>หัวข้อ</th>
            <th>ช่วงเวลา</th>
            <th>สถานะ</th>
            {canManage && <th></th>}
          </tr>
        </thead>
        <tbody>
          {plans.map((p) => (
            <tr key={p.id} style={{ borderTop: "1px solid #ddd" }}>
              <td>{nameOf(p.employee_id)}</td>
              <td>
                {p.topic}
                {p.reason && <div><small>{p.reason}</small></div>}
              </td>
              <td>
                {validDate(p.start_date) || "-"} ถึง {validDate(p.end_date) || "-"}
              </td>
              <td>{STATUS_LABEL[p.status]}</td>
              {canManage && (
                <td>
                  {NEXT[p.status].length > 0 && (
                    <button disabled={busy} onClick={() => startEdit(p)}>แก้ไข</button>
                  )}{" "}
                  {NEXT[p.status].map((s) => (
                    <button key={s} disabled={busy} onClick={() => changeStatus(p, s)}>
                      {STATUS_LABEL[s]}
                    </button>
                  ))}
                </td>
              )}
            </tr>
          ))}
        </tbody>
      </table>
      {plans.length === 0 && <p>ยังไม่มีแผนฝึกอบรม</p>}
    </div>
  );
}