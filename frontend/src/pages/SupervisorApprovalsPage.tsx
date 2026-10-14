import "../redesign.css";
import { useCallback, useEffect, useState } from "react";
import client, { errorMessage } from "../api/client";
import type { Criteria, Cycle, Evaluation, EvaluationStatus, Score, User } from "../types";

interface HistoryItem {
  id: number;
  cycle_id: number;
  cycle_name: string;
  employee_id: number;
  type: "self" | "supervisor";
  status: EvaluationStatus;
  total_score?: number;
}

const STATUS_LABEL: Record<EvaluationStatus, string> = {
  draft: "ร่าง",
  submitted: "ส่งแล้ว",
  approved: "อนุมัติแล้ว",
  rejected: "ถูกตีกลับ",
};

export default function SupervisorApprovalsPage() {
  const [team, setTeam] = useState<User[]>([]);
  const [history, setHistory] = useState<Record<number, HistoryItem[]>>({});
  const [cycles, setCycles] = useState<Cycle[]>([]);
  const [error, setError] = useState("");
  const [info, setInfo] = useState("");
  const [busy, setBusy] = useState(false);

  // ตีกลับ
  const [rejectId, setRejectId] = useState<number | null>(null);
  const [reason, setReason] = useState("");

  // ฟอร์มประเมินแบบหัวหน้า
  const [formFor, setFormFor] = useState<User | null>(null);
  const [formCycle, setFormCycle] = useState<number | null>(null);
  const [criteria, setCriteria] = useState<Criteria[]>([]);
  const [existing, setExisting] = useState<HistoryItem | null>(null);
  const [scores, setScores] = useState<Record<number, number>>({});
  const [comment, setComment] = useState("");
  const [saved, setSaved] = useState<Record<number, Score>>({}); // แถวคะแนนที่บันทึกไว้ (มีรายละเอียดของข้อ auto)
  const [notes, setNotes] = useState<Record<number, string>>({}); // หมายเหตุของข้อ auto

  const load = useCallback(async () => {
    try {
      const [t, c] = await Promise.all([client.get("/team"), client.get("/cycles")]);
      const members: User[] = t.data.data ?? [];
      setTeam(members);
      setCycles(c.data.data ?? []);
      const entries = await Promise.all(
        members.map(async (m) => {
          const res = await client.get(`/employees/${m.id}/evaluations`);
          return [m.id, (res.data.data ?? []) as HistoryItem[]] as const;
        })
      );
      setHistory(Object.fromEntries(entries));
    } catch (err) {
      setError(errorMessage(err));
    }
  }, []);

  useEffect(() => {
    load();
  }, [load]);

  // โหลดเกณฑ์และแบบเดิม (ถ้ามี) เมื่อเปิดฟอร์มหรือเปลี่ยนรอบ
  useEffect(() => {
    async function prepare() {
      setScores({});
      setComment("");
      setExisting(null);
      setSaved({});
      setNotes({});
      if (!formFor || formCycle === null) return;
      try {
        const k = await client.get(`/criteria?employee_id=${formFor.id}`);
        setCriteria(k.data.data ?? []);
        const found = (history[formFor.id] ?? []).find(
          (h) => h.cycle_id === formCycle && h.type === "supervisor"
        );
        if (found) {
          setExisting(found);
          const d = await client.get(`/evaluations/${found.id}`);
          const detail: Evaluation = d.data.data;
          setComment(detail.comment ?? "");
          const map: Record<number, number> = {};
          const rows: Record<number, Score> = {};
          const nts: Record<number, string> = {};
          (detail.scores ?? []).forEach((s) => {
            map[s.criteria_id] = s.score;
            rows[s.criteria_id] = s;
            nts[s.criteria_id] = s.comment ?? "";
          });
          setScores(map);
          setSaved(rows);
          setNotes(nts);
        }
      } catch (err) {
        setError(errorMessage(err));
      }
    }
    prepare();
  }, [formFor, formCycle, history]);

  async function act(path: string, body?: object, done = "ดำเนินการแล้ว") {
    setError("");
    setInfo("");
    setBusy(true);
    try {
      await client.post(path, body);
      setInfo(done);
      await load();
    } catch (err) {
      setError(errorMessage(err));
    } finally {
      setBusy(false);
    }
  }

  async function confirmReject() {
    if (rejectId === null) return;
    if (!reason.trim()) {
      setError("กรุณาระบุเหตุผลที่ตีกลับ");
      return;
    }
    await act(`/evaluations/${rejectId}/reject`, { reason }, "ตีกลับแล้ว");
    setRejectId(null);
    setReason("");
  }

  function openForm(m: User) {
    setError("");
    setInfo("");
    setFormFor(m);
    const open = cycles.find((c) => c.status === "open");
    setFormCycle(open ? open.id : null);
  }

  const cycleOpen = cycles.find((c) => c.id === formCycle)?.status === "open";
  const canEdit =
    cycleOpen && (!existing || existing.status === "draft" || existing.status === "rejected");

  const isAuto = (c: Criteria) => (c.source ?? "").startsWith("auto_");
  // ข้อ auto ที่ระบบคำนวณให้ (ถ้าแถวที่บันทึกไว้เป็น manual แปลว่าข้อมูลงานไม่พอ ต้องกรอกเอง)
  const autoLocked = (c: Criteria) => isAuto(c) && saved[c.id]?.source !== "manual";

  async function saveForm(submit: boolean) {
    setError("");
    setInfo("");
    if (!formFor || formCycle === null) return;
    const manual = criteria.filter((c) => !autoLocked(c));
    if (criteria.length === 0 || (submit && manual.some((c) => !scores[c.id]))) {
      setError("กรุณาให้คะแนนครบทุกเกณฑ์ (ข้อที่ระบบคำนวณให้ไม่ต้องกรอก)");
      return;
    }
    const payload = {
      comment,
      scores: criteria.map((c) =>
        autoLocked(c)
          ? { criteria_id: c.id, comment: notes[c.id] ?? "" }
          : { criteria_id: c.id, score: scores[c.id], comment: "" }
      ),
    };
    setBusy(true);
    try {
      let id = existing?.id;
      if (id) {
        await client.put(`/evaluations/${id}`, payload);
      } else {
        const res = await client.post("/evaluations", {
          ...payload,
          cycle_id: formCycle,
          employee_id: formFor.id,
          type: "supervisor",
        });
        id = res.data.data.id;
      }
      if (submit) await client.post(`/evaluations/${id}/submit`);
      setInfo(submit ? "ส่งผลประเมินแล้ว รอ HR อนุมัติ" : "บันทึกร่างแล้ว");
      if (submit) setFormFor(null);
      await load();
    } catch (err) {
      setError(errorMessage(err));
    } finally {
      setBusy(false);
    }
  }

  return (
    <div style={{ maxWidth: 820 }}>
      <h1>รออนุมัติ / ประเมินลูกทีม</h1>
      {error && <div className="error-box">{error}</div>}
      {info && <p>{info}</p>}
      {team.length === 0 && <p>ยังไม่มีลูกทีมในความดูแล</p>}

      {team.map((m) => (
        <section key={m.id} style={{ margin: "20px 0", padding: 12, border: "1px solid #ccc" }}>
          <h3>
            {m.name} <small>({m.position || "-"})</small>
          </h3>
          <button onClick={() => openForm(m)} disabled={busy}>
            ประเมินโดยหัวหน้า
          </button>

          {(history[m.id] ?? []).length === 0 && <p>ยังไม่มีแบบประเมิน</p>}
          {(history[m.id] ?? []).map((h) => (
            <div key={h.id} style={{ margin: "8px 0" }}>
              {h.cycle_name} · {h.type === "self" ? "ประเมินตนเอง" : "หัวหน้าประเมิน"} ·{" "}
              {STATUS_LABEL[h.status]}
              {h.total_score !== undefined && h.status !== "draft" && <> · คะแนน {h.total_score}</>}{" "}
              {h.type === "self" && h.status === "submitted" && (
                <>
                  <button disabled={busy} onClick={() => act(`/evaluations/${h.id}/approve`, undefined, "อนุมัติแล้ว")}>
                    อนุมัติ
                  </button>{" "}
                  <button disabled={busy} onClick={() => setRejectId(h.id)}>
                    ตีกลับ
                  </button>
                </>
              )}
              {h.type === "supervisor" && h.status === "submitted" && <small>(รอ HR อนุมัติ)</small>}
              {rejectId === h.id && (
                <div style={{ marginTop: 6 }}>
                  <input
                    placeholder="เหตุผลที่ตีกลับ"
                    value={reason}
                    onChange={(e) => setReason(e.target.value)}
                    style={{ width: 260 }}
                  />{" "}
                  <button disabled={busy} onClick={confirmReject}>ยืนยัน</button>{" "}
                  <button onClick={() => { setRejectId(null); setReason(""); }}>ยกเลิก</button>
                </div>
              )}
            </div>
          ))}
        </section>
      ))}

      {formFor && (
        <section style={{ margin: "24px 0", padding: 16, border: "2px solid #888" }}>
          <h2>ประเมิน {formFor.name}</h2>
          <label>
            รอบประเมิน{" "}
            <select value={formCycle ?? ""} onChange={(e) => setFormCycle(Number(e.target.value))}>
              {cycles.map((c) => (
                <option key={c.id} value={c.id}>
                  {c.name} {c.status === "closed" ? "(ปิดแล้ว)" : ""}
                </option>
              ))}
            </select>
          </label>
          {existing && <p>สถานะแบบนี้: {STATUS_LABEL[existing.status]}</p>}
          {!cycleOpen && <p>รอบนี้ปิดแล้ว ดูได้อย่างเดียว</p>}

          {criteria.map((c) => (
            <div key={c.id} style={{ margin: "14px 0" }}>
              <strong>{c.name}</strong> <small>(น้ำหนัก {c.weight})</small>
              {autoLocked(c) ? (
                <div>
                  <div><small>คำนวณอัตโนมัติจากข้อมูลงาน</small></div>
                  {saved[c.id] ? (
                    <div>
                      {saved[c.id].detail} → คะแนน <strong>{saved[c.id].score}</strong> / 5
                    </div>
                  ) : (
                    <div>
                      <small>{canEdit ? "ระบบจะคำนวณให้เมื่อกดบันทึกร่าง" : "-"}</small>
                    </div>
                  )}
                  <input
                    placeholder="หมายเหตุ (ไม่บังคับ)"
                    value={notes[c.id] ?? ""}
                    disabled={!canEdit}
                    onChange={(e) => setNotes({ ...notes, [c.id]: e.target.value })}
                    style={{ display: "block", width: "100%", marginTop: 4 }}
                  />
                </div>
              ) : (
                <div style={{ display: "flex", gap: 16, flexWrap: "wrap", marginTop: 6 }}>
                  {[1, 2, 3, 4, 5].map((n) => (
                    <label
                      key={n}
                      style={{ display: "inline-flex", flexDirection: "row", alignItems: "center", gap: 6, margin: 0, cursor: "pointer" }}
                    >
                      <input
                        type="radio"
                        name={`s-${c.id}`}
                        checked={scores[c.id] === n}
                        disabled={!canEdit}
                        onChange={() => setScores({ ...scores, [c.id]: n })}
                        style={{ width: "auto", margin: 0, padding: 0 }}
                      />
                      {n}
                    </label>
                  ))}
                </div>
              )}
            </div>
          ))}

          <label>
            ความเห็นหัวหน้า
            <textarea
              value={comment}
              disabled={!canEdit}
              onChange={(e) => setComment(e.target.value)}
              rows={4}
              style={{ display: "block", width: "100%" }}
            />
          </label>

          <div style={{ marginTop: 12, display: "flex", gap: 8 }}>
            {canEdit && (
              <>
                <button onClick={() => saveForm(false)} disabled={busy}>บันทึกร่าง</button>
                <button className="btn-primary" onClick={() => saveForm(true)} disabled={busy}>
                  ส่งผลประเมิน
                </button>
              </>
            )}
            <button onClick={() => setFormFor(null)}>ปิดฟอร์ม</button>
          </div>
        </section>
      )}
    </div>
  );
}