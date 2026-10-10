import "../redesign.css";
import { useCallback, useEffect, useState, type FormEvent } from "react";
import client, { errorMessage } from "../api/client";
import { useAuth } from "../context/AuthContext";
import type { Role, User } from "../types";

const ROLE_LABEL: Record<Role, string> = {
  employee: "พนักงาน",
  manager: "หัวหน้า",
  hr: "HR",
  accounting: "บัญชี",
  executive: "ผู้บริหาร",
};
const ROLES = Object.keys(ROLE_LABEL) as Role[];

interface FormState {
  employee_code: string;
  name: string;
  email: string;
  password: string;
  role: Role;
  department: string;
  position: string;
  level: string;
  manager_id: string;
}

const EMPTY: FormState = {
  employee_code: "",
  name: "",
  email: "",
  password: "",
  role: "employee",
  department: "",
  position: "",
  level: "",
  manager_id: "",
};

export default function HRUsersPage() {
  const { user: me } = useAuth();
  const [users, setUsers] = useState<User[]>([]);
  const [editing, setEditing] = useState<User | null>(null);
  const [form, setForm] = useState<FormState>(EMPTY);
  const [showForm, setShowForm] = useState(false);
  const [error, setError] = useState("");
  const [info, setInfo] = useState("");
  const [busy, setBusy] = useState(false);

  const load = useCallback(async () => {
    try {
      const res = await client.get("/users");
      setUsers(res.data.data ?? []);
    } catch (err) {
      setError(errorMessage(err));
    }
  }, []);

  useEffect(() => {
    load();
  }, [load]);

  function set<K extends keyof FormState>(key: K, value: FormState[K]) {
    setForm((f) => ({ ...f, [key]: value }));
  }

  function openCreate() {
    setError("");
    setInfo("");
    setEditing(null);
    setForm(EMPTY);
    setShowForm(true);
  }

  function openEdit(u: User) {
    setError("");
    setInfo("");
    setEditing(u);
    setForm({
      employee_code: u.employee_code,
      name: u.name,
      email: u.email,
      password: "",
      role: u.role,
      department: u.department ?? "",
      position: u.position ?? "",
      level: u.level ?? "",
      manager_id: u.manager_id ? String(u.manager_id) : "",
    });
    setShowForm(true);
  }

  function closeForm() {
    setShowForm(false);
    setEditing(null);
    setForm(EMPTY);
  }

  async function submit(e: FormEvent) {
    e.preventDefault();
    setError("");
    setInfo("");
    if (!form.employee_code.trim() || !form.name.trim() || !form.email.trim()) {
      setError("กรุณากรอกรหัสพนักงาน ชื่อ และอีเมล");
      return;
    }
    if (!editing && form.password.length < 8) {
      setError("รหัสผ่านต้องมีอย่างน้อย 8 ตัวอักษร");
      return;
    }
    const body: Record<string, unknown> = {
      employee_code: form.employee_code.trim(),
      name: form.name.trim(),
      email: form.email.trim(),
      role: form.role,
      department: form.department.trim(),
      position: form.position.trim(),
      level: form.level.trim(),
      manager_id: form.manager_id ? Number(form.manager_id) : null,
    };
    setBusy(true);
    try {
      if (editing) {
        await client.put(`/users/${editing.id}`, body);
        setInfo("แก้ไขข้อมูลผู้ใช้แล้ว");
      } else {
        await client.post("/users", { ...body, password: form.password });
        setInfo("สร้างผู้ใช้แล้ว");
      }
      closeForm();
      await load();
    } catch (err) {
      setError(errorMessage(err));
    } finally {
      setBusy(false);
    }
  }

  async function toggleActive(u: User) {
    const action = u.is_active ? "deactivate" : "activate";
    const label = u.is_active ? "ปิดใช้งาน" : "เปิดใช้งาน";
    if (!window.confirm(`${label}บัญชีของ ${u.name} ?`)) return;
    setError("");
    setInfo("");
    setBusy(true);
    try {
      await client.patch(`/users/${u.id}/${action}`);
      setInfo(`${label}แล้ว`);
      await load();
    } catch (err) {
      setError(errorMessage(err));
    } finally {
      setBusy(false);
    }
  }

  const managers = users.filter((u) => u.role === "manager" && u.is_active);
  const nameOf = (id: number | null) => users.find((u) => u.id === id)?.name ?? "-";

  return (
    <div style={{ maxWidth: 1100 }}>
      <h1>ผู้ใช้งาน</h1>
      <button className="btn-primary" onClick={openCreate} disabled={busy}>
        เพิ่มผู้ใช้
      </button>

      {showForm && (
        <form onSubmit={submit} style={{ display: "grid", gap: 10, maxWidth: 480, margin: "16px 0" }}>
          <h3>{editing ? `แก้ไข: ${editing.name}` : "เพิ่มผู้ใช้ใหม่"}</h3>
          <label>
            รหัสพนักงาน
            <input value={form.employee_code} onChange={(e) => set("employee_code", e.target.value)} style={{ display: "block", width: "100%" }} />
          </label>
          <label>
            ชื่อ นามสกุล
            <input value={form.name} onChange={(e) => set("name", e.target.value)} style={{ display: "block", width: "100%" }} />
          </label>
          <label>
            อีเมล
            <input type="email" value={form.email} onChange={(e) => set("email", e.target.value)} style={{ display: "block", width: "100%" }} />
          </label>
          {!editing && (
            <label>
              รหัสผ่าน (อย่างน้อย 8 ตัวอักษร)
              <input type="password" value={form.password} onChange={(e) => set("password", e.target.value)} autoComplete="new-password" style={{ display: "block", width: "100%" }} />
            </label>
          )}
          <label>
            บทบาท
            <select value={form.role} onChange={(e) => set("role", e.target.value as Role)} style={{ display: "block" }}>
              {ROLES.map((r) => (
                <option key={r} value={r}>{ROLE_LABEL[r]}</option>
              ))}
            </select>
          </label>
          <label>
            แผนก
            <input value={form.department} onChange={(e) => set("department", e.target.value)} style={{ display: "block", width: "100%" }} />
          </label>
          <label>
            ตำแหน่ง
            <input value={form.position} onChange={(e) => set("position", e.target.value)} style={{ display: "block", width: "100%" }} />
          </label>
          <label>
            ระดับ (เช่น junior, senior)
            <input value={form.level} onChange={(e) => set("level", e.target.value)} style={{ display: "block", width: "100%" }} />
          </label>
          <label>
            หัวหน้า
            <select value={form.manager_id} onChange={(e) => set("manager_id", e.target.value)} style={{ display: "block" }}>
              <option value="">ไม่มีหัวหน้า</option>
              {managers
                .filter((m) => m.id !== editing?.id)
                .map((m) => (
                  <option key={m.id} value={m.id}>{m.name}</option>
                ))}
            </select>
          </label>
          <div style={{ display: "flex", gap: 8 }}>
            <button type="submit" className="btn-primary" disabled={busy}>
              {editing ? "บันทึกการแก้ไข" : "สร้างผู้ใช้"}
            </button>
            <button type="button" onClick={closeForm}>ยกเลิก</button>
          </div>
          {editing && <small>แก้รหัสผ่านผ่านหน้านี้ไม่ได้</small>}
        </form>
      )}

      {error && <div className="error-box">{error}</div>}
      {info && <p>{info}</p>}

      <table style={{ width: "100%", borderCollapse: "collapse", marginTop: 16 }}>
        <thead>
          <tr style={{ textAlign: "left" }}>
            <th>รหัส</th>
            <th>ชื่อ</th>
            <th>อีเมล</th>
            <th>บทบาท</th>
            <th>แผนก</th>
            <th>ระดับ</th>
            <th>หัวหน้า</th>
            <th>สถานะ</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          {users.map((u) => (
            <tr key={u.id} style={{ borderTop: "1px solid #ddd", opacity: u.is_active ? 1 : 0.55 }}>
              <td>{u.employee_code}</td>
              <td>{u.name}</td>
              <td>{u.email}</td>
              <td>{ROLE_LABEL[u.role]}</td>
              <td>{u.department || "-"}</td>
              <td>{u.level || "-"}</td>
              <td>{nameOf(u.manager_id)}</td>
              <td>{u.is_active ? "ใช้งาน" : "ปิดใช้งาน"}</td>
              <td>
                <button disabled={busy} onClick={() => openEdit(u)}>แก้ไข</button>{" "}
                <button disabled={busy || u.id === me?.id} onClick={() => toggleActive(u)}>
                  {u.is_active ? "ปิดใช้งาน" : "เปิดใช้งาน"}
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
      {users.length === 0 && <p>ยังไม่มีผู้ใช้</p>}
    </div>
  );
}