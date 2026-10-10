import "../redesign.css";
import { useCallback, useEffect, useState, type FormEvent } from "react";
import client, { errorMessage } from "../api/client";
import type { Criteria, Department, Level } from "../types";

export default function HRCriteriaPage() {
  const [items, setItems] = useState<Criteria[]>([]);
  const [editing, setEditing] = useState<Criteria | null>(null);
  const [name, setName] = useState("");
  const [description, setDescription] = useState("");
  const [weight, setWeight] = useState("");
  const [rubric, setRubric] = useState("");
  const [department, setDepartment] = useState("");
  const [level, setLevel] = useState("");
  const [departments, setDepartments] = useState<Department[]>([]);
  const [levels, setLevels] = useState<Level[]>([]);
  const [error, setError] = useState("");
  const [info, setInfo] = useState("");
  const [busy, setBusy] = useState(false);

  const load = useCallback(async () => {
    try {
      const res = await client.get("/criteria");
      setItems(res.data.data ?? []);
    } catch (err) {
      setError(errorMessage(err));
    }
  }, []);

  useEffect(() => {
    load();
  }, [load]);

  useEffect(() => {
    async function loadOptions() {
      try {
        const [d, l] = await Promise.all([
          client.get("/departments"),
          client.get("/levels"),
        ]);
        setDepartments(d.data.data ?? []);
        setLevels(l.data.data ?? []);
      } catch (err) {
        setError(errorMessage(err));
      }
    }
    loadOptions();
  }, []);

  function resetForm() {
    setEditing(null);
    setName("");
    setDescription("");
    setWeight("");
    setRubric("");
    setDepartment("");
    setLevel("");
  }

  function startEdit(c: Criteria) {
    setError("");
    setInfo("");
    setEditing(c);
    setName(c.name);
    setDescription(c.description ?? "");
    setWeight(String(c.weight));
    setRubric(c.rubric ?? "");
    setDepartment(c.department ?? "");
    setLevel(c.level ?? "");
  }

  async function submit(e: FormEvent) {
    e.preventDefault();
    setError("");
    setInfo("");
    const w = Number(weight);
    if (!name.trim()) {
      setError("กรุณากรอกชื่อเกณฑ์");
      return;
    }
    if (!weight || Number.isNaN(w) || w <= 0) {
      setError("น้ำหนักต้องเป็นตัวเลขที่มากกว่า 0");
      return;
    }
    const body = {
      name: name.trim(),
      description,
      weight: w,
      rubric,
      department: department.trim(),
      level: level.trim(),
    };
    setBusy(true);
    try {
      if (editing) {
        await client.put(`/criteria/${editing.id}`, { ...body, is_active: editing.is_active ?? true });
        setInfo("แก้ไขเกณฑ์แล้ว");
      } else {
        await client.post("/criteria", body);
        setInfo("สร้างเกณฑ์แล้ว");
      }
      resetForm();
      await load();
    } catch (err) {
      const msg = errorMessage(err);
      // 409: เปลี่ยนน้ำหนัก/แผนก/ระดับ หลังมีแบบประเมินในระบบแล้ว
      setError(
        editing && msg.includes("ซ้ำ")
          ? "แก้น้ำหนัก แผนก หรือระดับไม่ได้ เพราะมีแบบประเมินในระบบแล้ว (แก้ชื่อ รายละเอียด และเกณฑ์ย่อยได้)"
          : msg
      );
    } finally {
      setBusy(false);
    }
  }

  async function deactivate(c: Criteria) {
    if (!window.confirm(`ปิดใช้งานเกณฑ์ "${c.name}" ?`)) return;
    setError("");
    setInfo("");
    setBusy(true);
    try {
      await client.put(`/criteria/${c.id}`, {
        name: c.name,
        description: c.description,
        weight: c.weight,
        rubric: c.rubric ?? "",
        department: c.department ?? "",
        level: c.level ?? "",
        is_active: false,
      });
      setInfo("ปิดใช้งานเกณฑ์แล้ว");
      if (editing?.id === c.id) resetForm();
      await load();
    } catch (err) {
      const msg = errorMessage(err);
      setError(
        msg.includes("ซ้ำ")
          ? "ปิดใช้งานไม่ได้ เพราะมีแบบประเมินในระบบแล้ว"
          : msg
      );
    } finally {
      setBusy(false);
    }
  }


  return (
    <div style={{ maxWidth: 900 }}>
      <h1>เกณฑ์ประเมิน</h1>

      <form onSubmit={submit} style={{ display: "grid", gap: 10, maxWidth: 480, margin: "16px 0" }}>
        <h3>{editing ? `แก้ไขเกณฑ์: ${editing.name}` : "สร้างเกณฑ์ใหม่"}</h3>
        <label>
          ชื่อเกณฑ์
          <input value={name} onChange={(e) => setName(e.target.value)} style={{ display: "block", width: "100%" }} />
        </label>
        <label>
          รายละเอียด
          <textarea value={description} onChange={(e) => setDescription(e.target.value)} rows={2} style={{ display: "block", width: "100%" }} />
        </label>
        <label>
          น้ำหนัก
          <input type="number" step="any" min="0" value={weight} onChange={(e) => setWeight(e.target.value)} style={{ display: "block" }} />
        </label>
        <label>
          เกณฑ์ย่อย / คำอธิบายระดับคะแนน (ไม่บังคับ)
          <textarea value={rubric} onChange={(e) => setRubric(e.target.value)} rows={2} style={{ display: "block", width: "100%" }} />
        </label>
        <label>
          ใช้กับแผนก
          <select value={department} onChange={(e) => setDepartment(e.target.value)} style={{ display: "block", width: "100%" }}>
            <option value="">ทุกแผนก</option>
            {department && !departments.some((d) => d.name === department) && (
              <option value={department}>{department} (ไม่อยู่ในรายการ)</option>
            )}
            {departments.map((d) => (
              <option key={d.id} value={d.name}>{d.name}</option>
            ))}
          </select>
        </label>
        <label>
          ใช้กับระดับ
          <select value={level} onChange={(e) => setLevel(e.target.value)} style={{ display: "block", width: "100%" }}>
            <option value="">ทุกระดับ</option>
            {level && !levels.some((l) => l.name === level) && (
              <option value={level}>{level} (ไม่อยู่ในรายการ)</option>
            )}
            {levels.map((l) => (
              <option key={l.id} value={l.name}>{l.name}</option>
            ))}
          </select>
        </label>
        <div style={{ display: "flex", gap: 8 }}>
          <button type="submit" className="btn-primary" disabled={busy}>
            {editing ? "บันทึกการแก้ไข" : "สร้างเกณฑ์"}
          </button>
          {editing && <button type="button" onClick={resetForm}>ยกเลิก</button>}
        </div>
      </form>

      {error && <div className="error-box">{error}</div>}
      {info && <p>{info}</p>}

      <table style={{ width: "100%", borderCollapse: "collapse" }}>
        <thead>
          <tr style={{ textAlign: "left" }}>
            <th>ชื่อเกณฑ์</th>
            <th>น้ำหนัก</th>
            <th>แผนก</th>
            <th>ระดับ</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          {items.map((c) => (
            <tr key={c.id} style={{ borderTop: "1px solid #ddd" }}>
              <td>
                {c.name}
                {c.description && <div><small>{c.description}</small></div>}
              </td>
              <td>{c.weight}</td>
              <td>{c.department || "ทุกแผนก"}</td>
              <td>{c.level || "ทุกระดับ"}</td>
              <td>
                <button disabled={busy} onClick={() => startEdit(c)}>แก้ไข</button>{" "}
                <button disabled={busy} onClick={() => deactivate(c)}>ปิดใช้งาน</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
      {items.length === 0 && <p>ยังไม่มีเกณฑ์ประเมิน</p>}

    </div>
  );
}