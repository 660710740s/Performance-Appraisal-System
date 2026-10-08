import { useEffect, useState } from "react";
import client, { errorMessage } from "../api/client";
import { useAuth } from "../context/AuthContext";
import type { Criteria, Cycle, Evaluation, EvaluationStatus } from "../types";

const STATUS_LABEL: Record<EvaluationStatus, string> = {
  draft: "ร่าง",
  submitted: "ส่งแล้ว รออนุมัติ",
  approved: "อนุมัติแล้ว",
  rejected: "ถูกตีกลับ (แก้ไขแล้วส่งใหม่ได้)",
};

export default function EmployeeEvaluationPage() {
  const { user } = useAuth();
  const [cycles, setCycles] = useState<Cycle[]>([]);
  const [criteria, setCriteria] = useState<Criteria[]>([]);
  const [given, setGiven] = useState<Evaluation[]>([]);
  const [cycleId, setCycleId] = useState<number | null>(null);
  const [current, setCurrent] = useState<Evaluation | null>(null);
  const [scores, setScores] = useState<Record<number, number>>({});
  const [comment, setComment] = useState("");
  const [error, setError] = useState("");
  const [info, setInfo] = useState("");
  const [busy, setBusy] = useState(false);

  // โหลดข้อมูลตั้งต้น
  useEffect(() => {
    async function load() {
      try {
        const [c, k, g] = await Promise.all([
          client.get("/cycles"),
          client.get("/criteria"),
          client.get("/evaluations/given"),
        ]);
        const cyc: Cycle[] = c.data.data ?? [];
        setCycles(cyc);
        setCriteria(k.data.data ?? []);
        setGiven(g.data.data ?? []);
        const firstOpen = cyc.find((x) => x.status === "open") ?? cyc[0];
        setCycleId(firstOpen ? firstOpen.id : null);
      } catch (err) {
        setError(errorMessage(err));
      }
    }
    load();
  }, []);

  // เมื่อเปลี่ยนรอบหรือรายการเปลี่ยน ให้หาแบบประเมินตนเองของรอบนั้น
  useEffect(() => {
    async function pick() {
      setScores({});
      setComment("");
      setCurrent(null);
      if (cycleId === null) return;
      const mine = given.find(
        (e) => e.cycle_id === cycleId && e.type === "self" && e.employee_id === user?.id
      );
      if (!mine) return;
      try {
        const res = await client.get(`/evaluations/${mine.id}`);
        const detail: Evaluation = res.data.data;
        setCurrent(detail);
        setComment(detail.comment ?? "");
        const map: Record<number, number> = {};
        (detail.scores ?? []).forEach((s) => (map[s.criteria_id] = s.score));
        setScores(map);
      } catch (err) {
        setError(errorMessage(err));
      }
    }
    pick();
  }, [cycleId, given, user?.id]);

  const cycle = cycles.find((c) => c.id === cycleId);
  const cycleOpen = cycle?.status === "open";
  const canEdit =
    cycleOpen && (!current || current.status === "draft" || current.status === "rejected");

  async function save(submit: boolean) {
    setError("");
    setInfo("");
    if (cycleId === null || !user) return;
    const missing = criteria.some((c) => !scores[c.id]);
    if (missing) {
      setError("กรุณาให้คะแนนครบทุกเกณฑ์");
      return;
    }
    const payload = {
      comment,
      scores: criteria.map((c) => ({ criteria_id: c.id, score: scores[c.id], comment: "" })),
    };
    setBusy(true);
    try {
      let id = current?.id;
      if (id) {
        await client.put(`/evaluations/${id}`, payload);
      } else {
        const res = await client.post("/evaluations", {
          ...payload,
          cycle_id: cycleId,
          employee_id: user.id,
          type: "self",
        });
        id = res.data.data.id;
      }
      if (submit) await client.post(`/evaluations/${id}/submit`);
      setInfo(submit ? "ส่งแบบประเมินแล้ว" : "บันทึกร่างแล้ว");
      const g = await client.get("/evaluations/given");
      setGiven(g.data.data ?? []);
    } catch (err) {
      setError(errorMessage(err));
    } finally {
      setBusy(false);
    }
  }

  return (
    <div style={{ maxWidth: 720 }}>
      <h1>ประเมินตนเอง</h1>

      <label>
        รอบประเมิน{" "}
        <select value={cycleId ?? ""} onChange={(e) => setCycleId(Number(e.target.value))}>
          {cycles.map((c) => (
            <option key={c.id} value={c.id}>
              {c.name} {c.status === "closed" ? "(ปิดแล้ว)" : ""}
            </option>
          ))}
        </select>
      </label>

      {current && <p>สถานะ: {STATUS_LABEL[current.status]}</p>}
      {current?.total_score !== undefined && current.status !== "draft" && (
        <p>คะแนนรวม: {current.total_score}</p>
      )}
      {!cycleOpen && cycle && <p>รอบนี้ปิดแล้ว ดูได้อย่างเดียว</p>}

      {criteria.map((c) => (
        <div key={c.id} style={{ margin: "16px 0" }}>
          <strong>{c.name}</strong> <small>(น้ำหนัก {c.weight})</small>
          {c.description && <div>{c.description}</div>}
          <div>
            {[1, 2, 3, 4, 5].map((n) => (
              <label key={n} style={{ marginRight: 12 }}>
                <input
                  type="radio"
                  name={`c-${c.id}`}
                  checked={scores[c.id] === n}
                  disabled={!canEdit}
                  onChange={() => setScores({ ...scores, [c.id]: n })}
                />{" "}
                {n}
              </label>
            ))}
          </div>
        </div>
      ))}

      <label>
        ความเห็นเพิ่มเติม
        <textarea
          value={comment}
          disabled={!canEdit}
          onChange={(e) => setComment(e.target.value)}
          rows={4}
          style={{ display: "block", width: "100%" }}
        />
      </label>

      {error && <div className="error-box">{error}</div>}
      {info && <p>{info}</p>}

      {canEdit && (
        <div style={{ marginTop: 16, display: "flex", gap: 8 }}>
          <button onClick={() => save(false)} disabled={busy}>บันทึกร่าง</button>
          <button className="btn-primary" onClick={() => save(true)} disabled={busy}>
            ส่งแบบประเมิน
          </button>
        </div>
      )}
    </div>
  );
}