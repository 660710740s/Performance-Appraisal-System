import "../redesign.css";
import { useCallback, useEffect, useState } from "react";
import client, { errorMessage } from "../api/client";
import type { Cycle } from "../types";
import {
  ResponsiveContainer, BarChart, Bar as RBar, XAxis, YAxis, Tooltip,
  CartesianGrid, PieChart, Pie, Cell, Legend,
} from "recharts";

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

const BONUS_STATUS = [
  { key: "pending_approval", label: "รออนุมัติ", color: "#c2410c" },
  { key: "approved", label: "อนุมัติแล้ว", color: "#15803d" },
  { key: "rejected", label: "ไม่อนุมัติ", color: "#be123c" },
];

function Bar({ pct, color = "#2563eb" }: { pct: number; color?: string }) {
  return (
    <div style={{ height: 10, borderRadius: 99, background: "#e8eef9", overflow: "hidden" }}>
      <div
        style={{
          width: `${Math.max(0, Math.min(100, pct))}%`,
          height: "100%",
          borderRadius: 99,
          background: color,
        }}
      />
    </div>
  );
}

function DeptChart({ data }: { data: Summary["departments"] }) {
  return (
    <ResponsiveContainer width="100%" height={260}>
      <BarChart data={data} margin={{ top: 8, right: 8, left: -16, bottom: 0 }}>
        <CartesianGrid strokeDasharray="3 3" vertical={false} />
        <XAxis dataKey="department" />
        <YAxis domain={[0, 5]} />
        <Tooltip formatter={(v) => Number(v).toFixed(2)} />
        <RBar dataKey="avg_score" name="คะแนนเฉลี่ย" fill="#2563eb" radius={[6, 6, 0, 0]} />
      </BarChart>
    </ResponsiveContainer>
  );
}

function BonusDonut({ data }: { data: Summary["bonuses"] }) {
  const rows = data.map((b) => {
    const s = BONUS_STATUS.find((x) => x.key === b.status);
    return { name: s?.label ?? b.status, value: b.count, color: s?.color ?? "#94a3b8" };
  });
  return (
    <ResponsiveContainer width="100%" height={260}>
      <PieChart>
        <Pie data={rows} dataKey="value" nameKey="name" innerRadius={55} outerRadius={90} paddingAngle={2}>
          {rows.map((r) => <Cell key={r.name} fill={r.color} />)}
        </Pie>
        <Tooltip />
        <Legend />
      </PieChart>
    </ResponsiveContainer>
  );
}

function ProgressChart({ data }: { data: Summary["progress"] }) {
  const rows = data.map((p) => ({
    name: p.cycle_name,
    approved: p.approved,
    remaining: Math.max(0, p.total_people - p.approved),
  }));
  return (
    <ResponsiveContainer width="100%" height={260}>
      <BarChart data={rows} margin={{ top: 8, right: 8, left: -16, bottom: 0 }}>
        <CartesianGrid strokeDasharray="3 3" vertical={false} />
        <XAxis dataKey="name" />
        <YAxis allowDecimals={false} />
        <Tooltip />
        <Legend />
        <RBar dataKey="approved" name="อนุมัติแล้ว" stackId="a" fill="#15803d" />
        <RBar dataKey="remaining" name="ยังไม่เสร็จ" stackId="a" fill="#cbd5e1" radius={[6, 6, 0, 0]} />
      </BarChart>
    </ResponsiveContainer>
  );
}

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
  const [selected, setSelected] = useState<Set<number>>(new Set());
  const [confirmBulk, setConfirmBulk] = useState(false);
  const [bulkNote, setBulkNote] = useState("");
  const [failures, setFailures] = useState<{ id: number; reason?: string }[]>([]);

  useEffect(() => {
    setSelected(new Set());
    setConfirmBulk(false);
  }, [cycleId, status]);

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

  const approvable = bonuses.filter((b) => b.status === "pending_approval");
  const allChecked = approvable.length > 0 && approvable.every((b) => selected.has(b.id));

  function toggleOne(id: number) {
    setConfirmBulk(false);
    setSelected((prev) => {
      const next = new Set(prev);
      if (next.has(id)) next.delete(id);
      else next.add(id);
      return next;
    });
  }

  function toggleAll() {
    setConfirmBulk(false);
    setSelected(allChecked ? new Set() : new Set(approvable.map((b) => b.id)));
  }

  async function approveSelected() {
    setError("");
    setInfo("");
    setFailures([]);
    setBusy(true);
    try {
      const res = await client.post("/executive/bonuses/approve-bulk", {
        ids: Array.from(selected),
        note: bulkNote,
      });
      const results: { id: number; ok: boolean; reason?: string }[] = res.data.data?.results ?? [];
      const bad = results.filter((x) => !x.ok);
      setInfo(`อนุมัติโบนัสสำเร็จ ${results.length - bad.length} / ไม่ผ่าน ${bad.length}`);
      setFailures(bad);
      setSelected(new Set());
      setConfirmBulk(false);
      setBulkNote("");
      await Promise.all([load(), loadSummary()]);
    } catch (err) {
      setError(errorMessage(err));
    } finally {
      setBusy(false);
    }
  }

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
        <section style={{ padding: "20px 24px", marginBottom: 24 }}>
          <div
            style={{
              display: "grid",
              gridTemplateColumns: "repeat(auto-fit, minmax(200px, 1fr))",
              gap: 14,
              marginBottom: 28,
            }}
          >
            {BONUS_STATUS.map((s) => {
              const row = (summary.bonuses ?? []).find((b) => b.status === s.key);
              return (
                <div
                  key={s.key}
                  style={{
                    padding: 18,
                    border: "1px solid #e7ebf2",
                    borderTop: `4px solid ${s.color}`,
                    borderRadius: 14,
                    background: "#fff",
                  }}
                >
                  <div style={{ fontSize: 12, color: "#667085" }}>โบนัส{s.label}</div>
                  <div style={{ fontSize: 28, fontWeight: 800, margin: "6px 0 2px" }}>
                    {row?.count ?? 0} <span style={{ fontSize: 13, fontWeight: 500 }}>รายการ</span>
                  </div>
                  <div style={{ fontSize: 13, color: s.color }}>
                    รวม {money(row?.total_amount ?? 0)} บาท
                  </div>
                </div>
              );
            })}
          </div>

          {/* ===== กราฟ ===== */}
          <div
            style={{
              display: "grid",
              gridTemplateColumns: "repeat(auto-fit, minmax(300px, 1fr))",
              gap: 14,
              marginBottom: 28,
            }}
          >
            {[
              { title: "คะแนนเฉลี่ยรายแผนก", chart: <DeptChart data={summary.departments ?? []} /> },
              { title: "จำนวนโบนัสตามสถานะ", chart: <BonusDonut data={summary.bonuses ?? []} /> },
              { title: "ความคืบหน้ารอบประเมิน", chart: <ProgressChart data={summary.progress ?? []} /> },
            ].map((c) => (
              <div
                key={c.title}
                style={{
                  padding: 18,
                  border: "1px solid #e7ebf2",
                  borderRadius: 14,
                  background: "#fff",
                }}
              >
                <div style={{ fontSize: 14, fontWeight: 700, marginBottom: 8 }}>{c.title}</div>
                {c.chart}
              </div>
            ))}
          </div>

          <h3>คะแนนเฉลี่ยตามแผนก</h3>
          {(summary.departments ?? []).length === 0 && <p>ยังไม่มีข้อมูล</p>}
          <div style={{ display: "grid", gap: 12, marginBottom: 28 }}>
            {(summary.departments ?? []).map((d) => (
              <div key={d.department}>
                <div style={{ display: "flex", justifyContent: "space-between", marginBottom: 6 }}>
                  <span>{d.department} <small>({d.employee_count} คน)</small></span>
                  <strong>{d.avg_score.toFixed(2)} / 5</strong>
                </div>
                <Bar pct={(d.avg_score / 5) * 100} />
              </div>
            ))}
          </div>

          <h3>ความคืบหน้าแต่ละรอบ</h3>
          <div style={{ display: "grid", gap: 12 }}>
            {(summary.progress ?? []).map((p) => {
              const pct = p.total_people ? (p.approved / p.total_people) * 100 : 0;
              return (
                <div key={p.cycle_id}>
                  <div style={{ display: "flex", justifyContent: "space-between", marginBottom: 6 }}>
                    <span>{p.cycle_name}</span>
                    <span>
                      อนุมัติแล้ว {p.approved} จาก {p.total_people} คน ({Math.round(pct)}%)
                    </span>
                  </div>
                  <Bar pct={pct} color="#0f766e" />
                </div>
              );
            })}
          </div>
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
      {failures.length > 0 && (
        <div className="error-box">
          <div>รายการที่ไม่ผ่าน:</div>
          {failures.map((f) => (
            <div key={f.id}>โบนัส #{f.id}: {f.reason}</div>
          ))}
        </div>
      )}
      {selected.size > 0 && (
        <div style={{ margin: "8px 0", display: "flex", gap: 8, alignItems: "center", flexWrap: "wrap" }}>
          <span>เลือกแล้ว {selected.size} รายการ</span>
          <input
            placeholder="หมายเหตุ (ไม่บังคับ)"
            value={bulkNote}
            onChange={(e) => setBulkNote(e.target.value)}
          />
          {!confirmBulk ? (
            <button className="btn-primary" disabled={busy} onClick={() => setConfirmBulk(true)}>
              อนุมัติที่เลือก ({selected.size})
            </button>
          ) : (
            <>
              <strong>ยืนยันอนุมัติโบนัส {selected.size} รายการ?</strong>
              <button className="btn-primary" disabled={busy} onClick={approveSelected}>ยืนยัน</button>
              <button disabled={busy} onClick={() => setConfirmBulk(false)}>ยกเลิก</button>
            </>
          )}
        </div>
      )}

      <table style={{ width: "100%", borderCollapse: "collapse" }}>
        <thead>
          <tr style={{ textAlign: "left" }}>
            <th>
              <input
                type="checkbox"
                checked={allChecked}
                onChange={toggleAll}
                disabled={busy || approvable.length === 0}
                title="เลือกทั้งหมดที่รออนุมัติ"
              />
            </th>
            <th>รอบ</th>
            <th>พนักงาน</th>
            <th>เงินเดือน</th>
            <th>คะแนน</th>
            <th>ยอดที่ระบบเสนอ</th>
            <th>ยอดที่ฝ่ายบัญชียืนยัน</th>
            <th>สถานะ</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          {bonuses.map((b) => (
            <tr key={b.id} style={{ borderTop: "1px solid #ddd" }}>
              <td>
                {b.status === "pending_approval" && (
                  <input
                    type="checkbox"
                    checked={selected.has(b.id)}
                    onChange={() => toggleOne(b.id)}
                    disabled={busy}
                  />
                )}
              </td>
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
