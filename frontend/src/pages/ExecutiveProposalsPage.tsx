import { useCallback, useEffect, useState } from "react";
import client, { errorMessage } from "../api/client";
import type { Cycle } from "../types";

type Decision = "pending_approval" | "approved" | "rejected";

interface Proposal {
  id: number;
  cycle_id: number;
  employee_id: number;
  status: Decision;
  note: string;
  decision_note: string;
  from_position?: string;
  to_position?: string;
  from_level?: string;
  to_level?: string;
  from_department?: string;
  to_department?: string;
  effective_date?: string | null;
}

const DECISION_LABEL: Record<Decision, string> = {
  pending_approval: "รออนุมัติ",
  approved: "อนุมัติแล้ว",
  rejected: "ไม่อนุมัติ",
};
const dateOnly = (iso?: string | null) => (iso && !iso.startsWith("0001") ? iso.slice(0, 10) : "-");

export default function ExecutiveProposalsPage() {
  const [tab, setTab] = useState<"promotions" | "transfers">("promotions");
  const [status, setStatus] = useState("pending_approval");
  const [rows, setRows] = useState<Proposal[]>([]);
  const [cycles, setCycles] = useState<Cycle[]>([]);
  const [noteFor, setNoteFor] = useState<number | null>(null);
  const [note, setNote] = useState("");
  const [error, setError] = useState("");
  const [info, setInfo] = useState("");
  const [busy, setBusy] = useState(false);

  useEffect(() => {
    client
      .get("/cycles")
      .then((res) => setCycles(res.data.data ?? []))
      .catch((err) => setError(errorMessage(err)));
  }, []);

  const load = useCallback(async () => {
    try {
      const res = await client.get(`/executive/${tab}`, { params: status ? { status } : {} });
      setRows(res.data.data ?? []);
    } catch (err) {
      setError(errorMessage(err));
    }
  }, [tab, status]);

  useEffect(() => {
    load();
  }, [load]);

  const cycleName = (id: number) => cycles.find((c) => c.id === id)?.name ?? `รอบ #${id}`;

  async function decide(id: number, action: "approve" | "reject") {
    setError("");
    setInfo("");
    setBusy(true);
    try {
      await client.post(`/executive/${tab}/${id}/${action}`, { note });
      setInfo(action === "approve" ? "อนุมัติแล้ว" : "ไม่อนุมัติแล้ว");
      setNoteFor(null);
      setNote("");
      await load();
    } catch (err) {
      setError(errorMessage(err));
    } finally {
      setBusy(false);
    }
  }

  return (
    <div style={{ maxWidth: 1000 }}>
      <h1>อนุมัติเลื่อนตำแหน่ง / โอนย้าย</h1>
      <div style={{ display: "flex", gap: 8, margin: "12px 0" }}>
        <button className={tab === "promotions" ? "btn-primary" : ""} style={{ width: "auto" }} onClick={() => { setTab("promotions"); setNoteFor(null); setError(""); setInfo(""); }}>
          เลื่อนตำแหน่ง
        </button>
        <button className={tab === "transfers" ? "btn-primary" : ""} style={{ width: "auto" }} onClick={() => { setTab("transfers"); setNoteFor(null); setError(""); setInfo(""); }}>
          โอนย้ายแผนก
        </button>
        <select value={status} onChange={(e) => setStatus(e.target.value)}>
          <option value="pending_approval">รออนุมัติ</option>
          <option value="approved">อนุมัติแล้ว</option>
          <option value="rejected">ไม่อนุมัติ</option>
          <option value="">ทุกสถานะ</option>
        </select>
      </div>

      {error && <div className="error-box">{error}</div>}
      {info && <p>{info}</p>}

      <table style={{ width: "100%", borderCollapse: "collapse" }}>
        <thead>
          <tr style={{ textAlign: "left" }}>
            <th>รอบ</th>
            <th>พนักงาน</th>
            <th>รายละเอียดข้อเสนอ</th>
            <th>สถานะ</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          {rows.map((r) => (
            <tr key={r.id} style={{ borderTop: "1px solid #ddd" }}>
              <td>{cycleName(r.cycle_id)}</td>
              <td>พนักงาน #{r.employee_id}</td>
              <td>
                {tab === "promotions" ? (
                  <>
                    {r.from_position || "-"} ({r.from_level || "-"}) → {r.to_position} ({r.to_level || "-"})
                  </>
                ) : (
                  <>
                    {r.from_department || "-"} → {r.to_department} · มีผล {dateOnly(r.effective_date)}
                  </>
                )}
                {r.note && <div><small>หมายเหตุ HR: {r.note}</small></div>}
              </td>
              <td>
                {DECISION_LABEL[r.status]}
                {r.decision_note && <div><small>{r.decision_note}</small></div>}
              </td>
              <td>
                {r.status === "pending_approval" && noteFor !== r.id && (
                  <button disabled={busy} onClick={() => { setNoteFor(r.id); setNote(""); }}>พิจารณา</button>
                )}
                {noteFor === r.id && (
                  <div style={{ display: "grid", gap: 6 }}>
                    <input placeholder="หมายเหตุ (ไม่บังคับ)" value={note} onChange={(e) => setNote(e.target.value)} />
                    <div>
                      <button disabled={busy} className="btn-primary" style={{ width: "auto" }} onClick={() => decide(r.id, "approve")}>อนุมัติ</button>{" "}
                      <button disabled={busy} onClick={() => decide(r.id, "reject")}>ไม่อนุมัติ</button>{" "}
                      <button onClick={() => setNoteFor(null)}>ยกเลิก</button>
                    </div>
                  </div>
                )}
              </td>
            </tr>
          ))}
        </tbody>
      </table>
      {rows.length === 0 && <p>ไม่มีรายการตามเงื่อนไขที่เลือก</p>}
    </div>
  );
}