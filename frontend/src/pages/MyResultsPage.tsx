import { useEffect, useState } from "react";
import client, { errorMessage } from "../api/client";
import type { Criteria, Cycle, Evaluation, EvaluationStatus } from "../types";

const STATUS_LABEL: Record<EvaluationStatus, string> = {
  draft: "ร่าง",
  submitted: "ส่งแล้ว",
  approved: "อนุมัติแล้ว",
  rejected: "ถูกตีกลับ",
};
const TYPE_LABEL = { self: "ประเมินตนเอง", supervisor: "หัวหน้าประเมิน" };

export default function MyResultsPage() {
  const [items, setItems] = useState<Evaluation[]>([]);
  const [cycles, setCycles] = useState<Cycle[]>([]);
  const [criteria, setCriteria] = useState<Criteria[]>([]);
  const [detail, setDetail] = useState<Evaluation | null>(null);
  const [feedback, setFeedback] = useState("");
  const [error, setError] = useState("");
  const [info, setInfo] = useState("");
  const [busy, setBusy] = useState(false);

  useEffect(() => {
    Promise.all([client.get("/evaluations/me"), client.get("/cycles"), client.get("/criteria")])
      .then(([e, c, k]) => {
        setItems(e.data.data ?? []);
        setCycles(c.data.data ?? []);
        setCriteria(k.data.data ?? []);
      })
      .catch((err) => setError(errorMessage(err)));
  }, []);

  async function open(id: number) {
    setError("");
    setInfo("");
    try {
      const res = await client.get(`/evaluations/${id}`);
      const d: Evaluation = res.data.data;
      setDetail(d);
      setFeedback(d.employee_feedback ?? "");
    } catch (err) {
      setError(errorMessage(err));
    }
  }

  async function sendFeedback() {
    if (!detail) return;
    if (!feedback.trim()) {
      setError("กรุณาพิมพ์ feedback");
      return;
    }
    setError("");
    setInfo("");
    setBusy(true);
    try {
      await client.post(`/evaluations/${detail.id}/feedback`, { feedback: feedback.trim() });
      const res = await client.get(`/evaluations/${detail.id}`);
      setDetail(res.data.data);
      setInfo("ส่ง feedback แล้ว");
    } catch (err) {
      setError(errorMessage(err));
    } finally {
      setBusy(false);
    }
  }

  const cycleName = (id: number) => cycles.find((c) => c.id === id)?.name ?? `รอบ #${id}`;
  const criteriaName = (id: number) => criteria.find((c) => c.id === id)?.name ?? `เกณฑ์ #${id}`;
  const canFeedback =
    detail?.type === "supervisor" && (detail.status === "submitted" || detail.status === "approved");

  return (
    <div style={{ maxWidth: 800 }}>
      <h1>ผลประเมินของฉัน</h1>
      {error && <div className="error-box">{error}</div>}
      {info && <p>{info}</p>}
      {items.length === 0 && <p>ยังไม่มีผลประเมิน</p>}

      <table style={{ width: "100%", borderCollapse: "collapse" }}>
        <thead>
          <tr style={{ textAlign: "left" }}>
            <th>รอบ</th>
            <th>ประเภท</th>
            <th>สถานะ</th>
            <th>คะแนน</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          {items.map((i) => (
            <tr key={i.id} style={{ borderTop: "1px solid #ddd" }}>
              <td>{cycleName(i.cycle_id)}</td>
              <td>{TYPE_LABEL[i.type]}</td>
              <td>{STATUS_LABEL[i.status]}</td>
              <td>{i.total_score ?? "-"}</td>
              <td>
                <button onClick={() => open(i.id)}>ดูรายละเอียด</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>

      {detail && (
        <section style={{ marginTop: 24, padding: 16, border: "1px solid #ccc" }}>
          <h3>
            {TYPE_LABEL[detail.type]} · {cycleName(detail.cycle_id)} · คะแนนรวม {detail.total_score ?? "-"}
          </h3>
          <ul>
            {(detail.scores ?? []).map((s) => (
              <li key={s.criteria_id}>
                {criteriaName(s.criteria_id)}: {s.score}
              </li>
            ))}
          </ul>
          {detail.comment && <p>ความเห็นผู้ประเมิน: {detail.comment}</p>}

          {canFeedback && (
            <div style={{ marginTop: 12 }}>
              <label>
                Feedback ของฉันต่อผลประเมินนี้
                <textarea
                  rows={3}
                  value={feedback}
                  onChange={(e) => setFeedback(e.target.value)}
                  style={{ display: "block", width: "100%" }}
                />
              </label>
              <button className="btn-primary" style={{ width: "auto" }} disabled={busy} onClick={sendFeedback}>
                ส่ง feedback
              </button>
            </div>
          )}
          <p>
            <button onClick={() => setDetail(null)}>ปิด</button>
          </p>
        </section>
      )}
    </div>
  );
}