import "../redesign.css";
import { useEffect, useState } from "react";
import client, { errorMessage } from "../api/client";
import type { Cycle } from "../types";

interface DeptScore {
  department: string;
  employee_count: number;
  avg_score: number;
}
interface Progress {
  cycle_id: number;
  cycle_name: string;
  total_people: number;
  not_started: number;
  draft: number;
  submitted: number;
  approved: number;
}
interface BonusSum {
  status: "pending_approval" | "approved" | "rejected";
  count: number;
  total_amount: number;
}
interface Summary {
  departments: DeptScore[];
  progress: Progress[];
  bonuses: BonusSum[];
}
interface Annual {
  year: number;
  cycles: { cycle_id: number; cycle_name: string; departments: DeptScore[] }[];
  departments: DeptScore[];
}

const BONUS_LABEL = { pending_approval: "รออนุมัติ", approved: "อนุมัติแล้ว", rejected: "ไม่อนุมัติ" };

function DeptTable({ rows }: { rows: DeptScore[] }) {
  if (rows.length === 0) return <p>ไม่มีข้อมูล</p>;
  return (
    <table style={{ borderCollapse: "collapse", minWidth: 420 }}>
      <thead>
        <tr style={{ textAlign: "left" }}>
          <th>แผนก</th>
          <th>จำนวนคน</th>
          <th>คะแนนเฉลี่ย</th>
        </tr>
      </thead>
      <tbody>
        {rows.map((d) => (
          <tr key={d.department} style={{ borderTop: "1px solid #ddd" }}>
            <td>{d.department}</td>
            <td>{d.employee_count}</td>
            <td>{d.avg_score.toFixed(2)}</td>
          </tr>
        ))}
      </tbody>
    </table>
  );
}

export default function ReportsPage() {
  const [cycles, setCycles] = useState<Cycle[]>([]);
  const [cycleId, setCycleId] = useState("");
  const [summary, setSummary] = useState<Summary | null>(null);
  const [year, setYear] = useState(String(new Date().getFullYear()));
  const [annual, setAnnual] = useState<Annual | null>(null);
  const [error, setError] = useState("");

  useEffect(() => {
    client
      .get("/cycles")
      .then((res) => setCycles(res.data.data ?? []))
      .catch((err) => setError(errorMessage(err)));
  }, []);

  useEffect(() => {
    client
      .get("/reports/summary", { params: cycleId ? { cycle_id: cycleId } : {} })
      .then((res) => setSummary(res.data.data))
      .catch((err) => setError(errorMessage(err)));
  }, [cycleId]);

  useEffect(() => {
    const y = Number(year);
    if (!y || y < 2000 || y > 2100) return;
    client
      .get("/reports/annual", { params: { year: y } })
      .then((res) => setAnnual(res.data.data))
      .catch((err) => setError(errorMessage(err)));
  }, [year]);

  return (
    <div style={{ maxWidth: 1000 }}>
      <h1>รายงานสรุปผล</h1>
      {error && <div className="error-box">{error}</div>}

      <h2>สรุปภาพรวม</h2>
      <label>
        รอบประเมิน{" "}
        <select value={cycleId} onChange={(e) => setCycleId(e.target.value)}>
          <option value="">ทุกรอบ</option>
          {cycles.map((c) => (
            <option key={c.id} value={c.id}>{c.name}</option>
          ))}
        </select>
      </label>

      {summary && (
        <>
          <h3>คะแนนเฉลี่ยตามแผนก (เฉพาะแบบที่หัวหน้าประเมินและอนุมัติแล้ว)</h3>
          <DeptTable rows={summary.departments ?? []} />

          <h3>ความคืบหน้าแต่ละรอบ</h3>
          <table style={{ borderCollapse: "collapse", width: "100%" }}>
            <thead>
              <tr style={{ textAlign: "left" }}>
                <th>รอบ</th>
                <th>ทั้งหมด (คน)</th>
                <th>ยังไม่เริ่ม</th>
                <th>ร่าง</th>
                <th>ส่งแล้ว</th>
                <th>อนุมัติแล้ว</th>
              </tr>
            </thead>
            <tbody>
              {(summary.progress ?? []).map((p) => (
                <tr key={p.cycle_id} style={{ borderTop: "1px solid #ddd" }}>
                  <td>{p.cycle_name}</td>
                  <td>{p.total_people}</td>
                  <td>{p.not_started}</td>
                  <td>{p.draft}</td>
                  <td>{p.submitted}</td>
                  <td>{p.approved}</td>
                </tr>
              ))}
            </tbody>
          </table>

          <h3>โบนัสตามสถานะ</h3>
          <table style={{ borderCollapse: "collapse", minWidth: 420 }}>
            <thead>
              <tr style={{ textAlign: "left" }}>
                <th>สถานะ</th>
                <th>จำนวน</th>
                <th>ยอดรวม (บาท)</th>
              </tr>
            </thead>
            <tbody>
              {(summary.bonuses ?? []).map((b) => (
                <tr key={b.status} style={{ borderTop: "1px solid #ddd" }}>
                  <td>{BONUS_LABEL[b.status]}</td>
                  <td>{b.count}</td>
                  <td>{b.total_amount.toLocaleString("th-TH")}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </>
      )}

      <h2 style={{ marginTop: 32 }}>รายงานประจำปี</h2>
      <label>
        ปี (ค.ศ.){" "}
        <input type="number" value={year} onChange={(e) => setYear(e.target.value)} style={{ width: 100 }} />
      </label>

      {annual && (
        <>
          <h3>รวมทั้งปี {annual.year}</h3>
          <DeptTable rows={annual.departments ?? []} />
          {(annual.cycles ?? []).map((c) => (
            <div key={c.cycle_id}>
              <h3>{c.cycle_name}</h3>
              <DeptTable rows={c.departments ?? []} />
            </div>
          ))}
        </>
      )}
    </div>
  );
}