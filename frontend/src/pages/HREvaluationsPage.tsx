import "../redesign.css";
import { useCallback, useEffect, useState } from "react";
import client, { errorMessage } from "../api/client";
import type { Cycle, EvaluationStatus } from "../types";

interface ReportRow {
  id: number;
  cycle_id: number;
  cycle_name: string;
  employee_id: number;
  employee_name: string;
  department: string;
  level: string;
  type: "self" | "supervisor";
  evaluator_id: number;
  evaluator_name: string;
  status: EvaluationStatus;
  total_score?: number;
  submitted_at?: string;
  approved_at?: string;
}

const STATUS_LABEL: Record<EvaluationStatus, string> = {
  draft: "ร่าง",
  submitted: "ส่งแล้ว",
  approved: "อนุมัติแล้ว",
  rejected: "ถูกตีกลับ",
};

const TYPE_LABEL = { self: "ประเมินตนเอง", supervisor: "หัวหน้าประเมิน" };
const PAGE_SIZE = 20;

export default function HREvaluationsPage() {
  const [cycles, setCycles] = useState<Cycle[]>([]);
  const [rows, setRows] = useState<ReportRow[]>([]);
  const [cycleId, setCycleId] = useState("");
  const [status, setStatus] = useState("");
  const [type, setType] = useState("");
  const [department, setDepartment] = useState("");
  const [offset, setOffset] = useState(0);
  const [loading, setLoading] = useState(false);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState("");
  const [info, setInfo] = useState("");
  const [rejectId, setRejectId] = useState<number | null>(null);
  const [reason, setReason] = useState("");

  useEffect(() => {
    client
      .get("/cycles")
      .then((res) => setCycles(res.data.data ?? []))
      .catch((err) => setError(errorMessage(err)));
  }, []);

  const load = useCallback(async () => {
    setLoading(true);
    try {
      const params: Record<string, string | number> = { limit: PAGE_SIZE, offset };
      if (cycleId) params.cycle_id = cycleId;
      if (status) params.status = status;
      if (type) params.type = type;
      if (department.trim()) params.department = department.trim();
      const res = await client.get("/reports/evaluations", { params });
      setRows(res.data.data ?? []);
    } catch (err) {
      setError(errorMessage(err));
    } finally {
      setLoading(false);
    }
  }, [cycleId, status, type, department, offset]);

  useEffect(() => {
    load();
  }, [load]);

  function changeFilter(setter: (v: string) => void, value: string) {
    setter(value);
    setOffset(0);
  }

  async function act(path: string, body: object | undefined, done: string) {
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

  return (
    <div style={{ maxWidth: 1000 }}>
      <h1>แบบประเมินทั้งหมด</h1>

      <div style={{ display: "flex", gap: 12, flexWrap: "wrap", margin: "12px 0" }}>
        <select value={cycleId} onChange={(e) => changeFilter(setCycleId, e.target.value)}>
          <option value="">ทุกรอบ</option>
          {cycles.map((c) => (
            <option key={c.id} value={c.id}>{c.name}</option>
          ))}
        </select>
        <select value={status} onChange={(e) => changeFilter(setStatus, e.target.value)}>
          <option value="">ทุกสถานะ</option>
          <option value="draft">ร่าง</option>
          <option value="submitted">ส่งแล้ว</option>
          <option value="approved">อนุมัติแล้ว</option>
          <option value="rejected">ถูกตีกลับ</option>
        </select>
        <select value={type} onChange={(e) => changeFilter(setType, e.target.value)}>
          <option value="">ทุกประเภท</option>
          <option value="self">ประเมินตนเอง</option>
          <option value="supervisor">หัวหน้าประเมิน</option>
        </select>
        <input
          placeholder="แผนก (ตรงตามชื่อ)"
          value={department}
          onChange={(e) => changeFilter(setDepartment, e.target.value)}
        />
      </div>

      {error && <div className="error-box">{error}</div>}
      {info && <p>{info}</p>}

      <table style={{ width: "100%", borderCollapse: "collapse" }}>
        <thead>
          <tr style={{ textAlign: "left" }}>
            <th>รอบ</th>
            <th>พนักงาน</th>
            <th>แผนก</th>
            <th>ประเภท</th>
            <th>ผู้ประเมิน</th>
            <th>สถานะ</th>
            <th>คะแนน</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          {rows.map((r) => (
            <tr key={r.id} style={{ borderTop: "1px solid #ddd" }}>
              <td>{r.cycle_name}</td>
              <td>{r.employee_name}</td>
              <td>{r.department}</td>
              <td>{TYPE_LABEL[r.type]}</td>
              <td>{r.evaluator_name}</td>
              <td>{STATUS_LABEL[r.status]}</td>
              <td>{r.status === "draft" ? "-" : r.total_score ?? "-"}</td>
              <td>
                {r.status === "submitted" && (
                  <>
                    <button
                      disabled={busy}
                      onClick={() => act(`/evaluations/${r.id}/approve`, undefined, "อนุมัติแล้ว")}
                    >
                      อนุมัติ
                    </button>{" "}
                    <button disabled={busy} onClick={() => setRejectId(r.id)}>ตีกลับ</button>
                  </>
                )}
                {rejectId === r.id && (
                  <div style={{ marginTop: 6 }}>
                    <input
                      placeholder="เหตุผลที่ตีกลับ"
                      value={reason}
                      onChange={(e) => setReason(e.target.value)}
                    />{" "}
                    <button disabled={busy} onClick={confirmReject}>ยืนยัน</button>{" "}
                    <button onClick={() => { setRejectId(null); setReason(""); }}>ยกเลิก</button>
                  </div>
                )}
              </td>
            </tr>
          ))}
        </tbody>
      </table>

      {!loading && rows.length === 0 && <p>ไม่พบแบบประเมินตามเงื่อนไขที่เลือก</p>}
      {loading && <p>กำลังโหลด...</p>}

      <div style={{ marginTop: 12, display: "flex", gap: 8, alignItems: "center" }}>
        <button disabled={offset === 0 || loading} onClick={() => setOffset(Math.max(0, offset - PAGE_SIZE))}>
          ก่อนหน้า
        </button>
        <span>หน้า {offset / PAGE_SIZE + 1}</span>
        <button disabled={rows.length < PAGE_SIZE || loading} onClick={() => setOffset(offset + PAGE_SIZE)}>
          ถัดไป
        </button>
      </div>
    </div>
  );
}