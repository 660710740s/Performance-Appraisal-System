import { useCallback, useEffect, useState } from "react";
import client, { errorMessage } from "../api/client";
import type { User } from "../types";

// รูปแบบ response ของ /audit-logs ฉันยังไม่เคยเห็น จึงรับแบบยืดหยุ่น
interface LogRow {
  id: number;
  user_id?: number | null;
  action?: string;
  entity?: string;
  entity_id?: number | null;
  created_at?: string;
  [key: string]: unknown;
}

const PAGE_SIZE = 50;

export default function AuditLogPage() {
  const [rows, setRows] = useState<LogRow[]>([]);
  const [users, setUsers] = useState<User[]>([]);
  const [entity, setEntity] = useState("");
  const [userId, setUserId] = useState("");
  const [offset, setOffset] = useState(0);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  useEffect(() => {
    client
      .get("/users")
      .then((res) => setUsers(res.data.data ?? []))
      .catch((err) => setError(errorMessage(err)));
  }, []);

  const load = useCallback(async () => {
    setLoading(true);
    try {
      const params: Record<string, string | number> = { limit: PAGE_SIZE, offset };
      if (entity.trim()) params.entity = entity.trim();
      if (userId) params.user_id = userId;
      const res = await client.get("/audit-logs", { params });
      setRows(res.data.data ?? []);
    } catch (err) {
      setError(errorMessage(err));
    } finally {
      setLoading(false);
    }
  }, [entity, userId, offset]);

  useEffect(() => {
    load();
  }, [load]);

  const nameOf = (id?: number | null) =>
    id ? users.find((u) => u.id === id)?.name ?? `#${id}` : "-";

  return (
    <div style={{ maxWidth: 1100 }}>
      <h1>Audit log</h1>
      <div style={{ display: "flex", gap: 12, margin: "12px 0" }}>
        <input
          placeholder="ประเภทข้อมูล (entity)"
          value={entity}
          onChange={(e) => { setEntity(e.target.value); setOffset(0); }}
        />
        <select value={userId} onChange={(e) => { setUserId(e.target.value); setOffset(0); }}>
          <option value="">ทุกคน</option>
          {users.map((u) => (
            <option key={u.id} value={u.id}>{u.name}</option>
          ))}
        </select>
      </div>

      {error && <div className="error-box">{error}</div>}

      <table style={{ width: "100%", borderCollapse: "collapse" }}>
        <thead>
          <tr style={{ textAlign: "left" }}>
            <th>เวลา</th>
            <th>ผู้ทำรายการ</th>
            <th>การกระทำ</th>
            <th>ข้อมูล</th>
            <th>รายละเอียดดิบ</th>
          </tr>
        </thead>
        <tbody>
          {rows.map((r) => (
            <tr key={r.id} style={{ borderTop: "1px solid #ddd" }}>
              <td>{r.created_at ? r.created_at.slice(0, 19).replace("T", " ") : "-"}</td>
              <td>{nameOf(r.user_id)}</td>
              <td>{r.action ?? "-"}</td>
              <td>
                {r.entity ?? "-"} {r.entity_id ?? ""}
              </td>
              <td>
                <details>
                  <summary>ดู</summary>
                  <pre style={{ fontSize: 12, whiteSpace: "pre-wrap" }}>{JSON.stringify(r, null, 2)}</pre>
                </details>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
      {!loading && rows.length === 0 && <p>ไม่พบรายการ</p>}

      <div style={{ marginTop: 12, display: "flex", gap: 8, alignItems: "center" }}>
        <button disabled={offset === 0 || loading} onClick={() => setOffset(Math.max(0, offset - PAGE_SIZE))}>ก่อนหน้า</button>
        <span>หน้า {offset / PAGE_SIZE + 1}</span>
        <button disabled={rows.length < PAGE_SIZE || loading} onClick={() => setOffset(offset + PAGE_SIZE)}>ถัดไป</button>
      </div>
    </div>
  );
}