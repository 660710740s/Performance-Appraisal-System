import "../redesign.css";
import { useCallback, useEffect, useState, type FormEvent } from "react";
import client, { errorMessage } from "../api/client";
import type { Cycle } from "../types";

const toDateInput = (iso: string) => iso.slice(0, 10);
const toIso = (d: string) => `${d}T00:00:00Z`;

export default function HRCyclesPage() {
  const [cycles, setCycles] = useState<Cycle[]>([]);
  const [editingId, setEditingId] = useState<number | null>(null);
  const [name, setName] = useState("");
  const [startDate, setStartDate] = useState("");
  const [endDate, setEndDate] = useState("");
  const [error, setError] = useState("");
  const [info, setInfo] = useState("");
  const [busy, setBusy] = useState(false);

  const load = useCallback(async () => {
    try {
      const res = await client.get("/cycles");
      setCycles(res.data.data ?? []);
    } catch (err) {
      setError(errorMessage(err));
    }
  }, []);

  useEffect(() => {
    load();
  }, [load]);

  function resetForm() {
    setEditingId(null);
    setName("");
    setStartDate("");
    setEndDate("");
  }

  function startEdit(c: Cycle) {
    setError("");
    setInfo("");
    setEditingId(c.id);
    setName(c.name);
    setStartDate(toDateInput(c.start_date));
    setEndDate(toDateInput(c.end_date));
  }

  async function submit(e: FormEvent) {
    e.preventDefault();
    setError("");
    setInfo("");
    if (!name.trim() || !startDate || !endDate) {
      setError("กรุณากรอกชื่อรอบ วันเริ่ม และวันสิ้นสุด");
      return;
    }
    if (endDate <= startDate) {
      setError("วันสิ้นสุดต้องหลังวันเริ่ม");
      return;
    }
    const body = { name: name.trim(), start_date: toIso(startDate), end_date: toIso(endDate) };
    setBusy(true);
    try {
      if (editingId) {
        await client.put(`/cycles/${editingId}`, body);
        setInfo("แก้ไขรอบประเมินแล้ว");
      } else {
        await client.post("/cycles", body);
        setInfo("สร้างรอบประเมินแล้ว");
      }
      resetForm();
      await load();
    } catch (err) {
      setError(errorMessage(err));
    } finally {
      setBusy(false);
    }
  }

  async function closeCycle(c: Cycle) {
    if (!window.confirm(`ปิดรอบ "${c.name}" ? ปิดแล้วจะเปิดกลับและแก้ไขไม่ได้`)) return;
    setError("");
    setInfo("");
    setBusy(true);
    try {
      await client.put(`/cycles/${c.id}`, {
        name: c.name,
        start_date: c.start_date,
        end_date: c.end_date,
        status: "closed",
      });
      setInfo("ปิดรอบแล้ว");
      if (editingId === c.id) resetForm();
      await load();
    } catch (err) {
      setError(errorMessage(err));
    } finally {
      setBusy(false);
    }
  }

  return (
    <div style={{ maxWidth: 800 }}>
      <h1>รอบประเมิน</h1>

      <form onSubmit={submit} style={{ display: "grid", gap: 10, maxWidth: 420, margin: "16px 0" }}>
        <h3>{editingId ? "แก้ไขรอบประเมิน" : "สร้างรอบประเมินใหม่"}</h3>
        <label>
          ชื่อรอบ
          <input value={name} onChange={(e) => setName(e.target.value)} style={{ display: "block", width: "100%" }} />
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
          <button type="submit" className="btn-primary" disabled={busy}>
            {editingId ? "บันทึกการแก้ไข" : "สร้างรอบ"}
          </button>
          {editingId && (
            <button type="button" onClick={resetForm}>ยกเลิก</button>
          )}
        </div>
      </form>

      {error && <div className="error-box">{error}</div>}
      {info && <p>{info}</p>}

      <table style={{ width: "100%", borderCollapse: "collapse" }}>
        <thead>
          <tr style={{ textAlign: "left" }}>
            <th>ชื่อรอบ</th>
            <th>วันเริ่ม</th>
            <th>วันสิ้นสุด</th>
            <th>สถานะ</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          {cycles.map((c) => (
            <tr key={c.id} style={{ borderTop: "1px solid #ddd" }}>
              <td>{c.name}</td>
              <td>{toDateInput(c.start_date)}</td>
              <td>{toDateInput(c.end_date)}</td>
              <td>{c.status === "open" ? "เปิดอยู่" : "ปิดแล้ว"}</td>
              <td>
                {c.status === "open" && (
                  <>
                    <button disabled={busy} onClick={() => startEdit(c)}>แก้ไข</button>{" "}
                    <button disabled={busy} onClick={() => closeCycle(c)}>ปิดรอบ</button>
                  </>
                )}
              </td>
            </tr>
          ))}
        </tbody>
      </table>
      {cycles.length === 0 && <p>ยังไม่มีรอบประเมิน</p>}
    </div>
  );
}