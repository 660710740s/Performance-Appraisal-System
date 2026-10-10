import "../redesign.css";
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

  const answeredCount = criteria.filter((c) => Boolean(scores[c.id])).length;
  const progress = criteria.length ? Math.round((answeredCount / criteria.length) * 100) : 0;

  return (
    <div className="self-eval-page">
      <header className="self-eval-hero">
        <div className="self-eval-hero-orb self-eval-hero-orb-one" />
        <div className="self-eval-hero-orb self-eval-hero-orb-two" />
        <div className="self-eval-hero-content">
          <span className="self-eval-eyebrow">PERFORMANCE REVIEW · 2026</span>
          <h1>ประเมินตนเอง</h1>
          <p>ทบทวนผลงานและพัฒนาการของคุณในรอบการประเมินนี้</p>
          <div className="self-eval-progress-meta">
            <span>ความคืบหน้าในการประเมิน</span>
            <strong>{answeredCount}/{criteria.length} ข้อ</strong>
          </div>
          <div className="self-eval-progress-track">
            <div className="self-eval-progress-fill" style={{ width: `${progress}%` }} />
          </div>
        </div>
        <div className="self-eval-hero-badge">
          <span>ความคืบหน้า</span>
          <strong>{progress}%</strong>
          <small>ตอบแล้ว</small>
        </div>
      </header>

      <section className="self-eval-cycle-card">
        <div className="self-eval-cycle-icon">✦</div>
        <div className="self-eval-cycle-copy">
          <strong>รอบการประเมิน</strong>
          <span>เลือกรอบที่ต้องการประเมิน</span>
        </div>
        <select aria-label="รอบประเมิน" value={cycleId ?? ""} onChange={(e) => setCycleId(Number(e.target.value))}>
          {cycles.map((c) => (
            <option key={c.id} value={c.id}>
              {c.name} {c.status === "closed" ? "(ปิดแล้ว)" : ""}
            </option>
          ))}
        </select>
      </section>

      {current && (
        <div className={`self-eval-status-banner self-eval-status-${current.status}`}>
          <span className="self-eval-status-dot" />
          <span>สถานะ: <strong>{STATUS_LABEL[current.status]}</strong></span>
          {current.total_score !== undefined && current.status !== "draft" && (
            <span className="self-eval-score-pill">คะแนนรวม {current.total_score}</span>
          )}
        </div>
      )}
      {!cycleOpen && cycle && (
        <div className="self-eval-notice"><span>ⓘ</span> รอบนี้ปิดแล้ว คุณสามารถดูข้อมูลได้อย่างเดียว</div>
      )}
      {error && <div className="error-box">{error}</div>}
      {info && <div className="self-eval-success">✓ {info}</div>}

      <div className="self-eval-section-heading">
        <div>
          <span className="self-eval-section-kicker">YOUR REVIEW</span>
          <h2>เกณฑ์การประเมิน</h2>
          <p>เลือกคะแนน 1–5 ให้ตรงกับผลงานของคุณในแต่ละหัวข้อ</p>
        </div>
        <span className="self-eval-count-badge">{criteria.length} เกณฑ์</span>
      </div>

      <div className="self-eval-criteria-list">
        {criteria.map((c, index) => (
          <article key={c.id} className={`self-eval-criterion-card ${scores[c.id] ? "is-answered" : ""}`}>
            <div className="self-eval-criterion-top">
              <div className={`self-eval-criterion-number tone-${index % 5}`}>{String(index + 1).padStart(2, "0")}</div>
              <div className="self-eval-criterion-title-wrap">
                <h3>{c.name}</h3>
                {c.description && <p>{c.description}</p>}
              </div>
              <span className="self-eval-weight">น้ำหนัก <strong>{c.weight}</strong></span>
            </div>
            <div className="self-eval-rating-label">
              <span>ให้คะแนนตัวเอง</span>
              {scores[c.id] ? <strong className="self-eval-selected-label">เลือก {scores[c.id]} / 5</strong> : <small>ยังไม่ได้ให้คะแนน</small>}
            </div>
            <div className="self-eval-rating-options" role="radiogroup" aria-label={`คะแนน ${c.name}`}>
              {[1, 2, 3, 4, 5].map((n) => (
                <label key={n} className={`self-eval-rating-option rating-${n} ${scores[c.id] === n ? "selected" : ""} ${!canEdit ? "disabled" : ""}`}>
                  <input
                    type="radio"
                    name={`c-${c.id}`}
                    value={n}
                    checked={scores[c.id] === n}
                    disabled={!canEdit}
                    onChange={() => setScores({ ...scores, [c.id]: n })}
                  />
                  <span className="self-eval-rating-number">{n}</span>
                  <span className="self-eval-rating-word">{["ต้องปรับปรุง", "พอใช้", "ตามเป้าหมาย", "ดีมาก", "ยอดเยี่ยม"][n - 1]}</span>
                </label>
              ))}
            </div>
          </article>
        ))}
      </div>

      <section className="self-eval-comment-card">
        <div className="self-eval-comment-icon">✎</div>
        <div className="self-eval-comment-heading">
          <h3>ความเห็นเพิ่มเติม</h3>
          <p>บอกเล่าผลงาน ความสำเร็จ หรือสิ่งที่อยากพัฒนาเพิ่มเติม (ถ้ามี)</p>
        </div>
        <textarea
          value={comment}
          disabled={!canEdit}
          onChange={(e) => setComment(e.target.value)}
          rows={4}
          placeholder="พิมพ์ความเห็นของคุณที่นี่..."
        />
      </section>

      {canEdit && (
        <footer className="self-eval-actions">
          <div className="self-eval-actions-note">
            <span className="self-eval-save-dot" />
            <span>คุณสามารถบันทึกร่างและกลับมาแก้ไขภายหลังได้</span>
          </div>
          <div className="self-eval-action-buttons">
            <button className="self-eval-save-button" onClick={() => save(false)} disabled={busy}>
              {busy ? "กำลังบันทึก..." : "บันทึกร่าง"}
            </button>
            <button className="self-eval-submit-button" onClick={() => save(true)} disabled={busy || answeredCount !== criteria.length}>
              {busy ? "กำลังส่ง..." : "ส่งแบบประเมิน  →"}
            </button>
          </div>
        </footer>
      )}
    </div>
  );
}
