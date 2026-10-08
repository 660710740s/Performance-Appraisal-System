import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import client from "../api/client";
import { useAuth } from "../context/AuthContext";
import { NAV_ITEMS } from "../config/navigation";
import type { Role } from "../types";

interface Stat {
  label: string;
  value: number | string;
  to?: string;
}

const ROLE_LABEL: Record<Role, string> = {
  employee: "พนักงาน",
  manager: "หัวหน้า",
  hr: "HR",
  accounting: "บัญชี",
  executive: "ผู้บริหาร",
};

const list = async (path: string, params?: Record<string, string | number>) => {
  const res = await client.get(path, { params });
  return (res.data.data ?? []) as Record<string, unknown>[];
};

export default function DashboardPage() {
  const { user } = useAuth();
  const [stats, setStats] = useState<Stat[]>([]);

  useEffect(() => {
    if (!user) return;
    async function load() {
      const out: Stat[] = [];
      // แต่ละรายการล้มเหลวได้โดยไม่กระทบรายการอื่น
      const add = async (label: string, fn: () => Promise<number | string>, to?: string) => {
        try {
          out.push({ label, value: await fn(), to });
        } catch {
          /* ข้ามรายการที่โหลดไม่ได้ */
        }
      };

      if (user!.role === "employee" || user!.role === "manager") {
        await add("ผลประเมินของฉัน (ส่งแล้ว/อนุมัติแล้ว)", async () => (await list("/evaluations/me")).length, "/results");
        await add(
          "คะแนนล่าสุดจากหัวหน้า",
          async () => {
            const sup = (await list("/evaluations/me")).filter((e) => e.type === "supervisor" && e.status === "approved");
            const last = sup[sup.length - 1];
            return last ? String(last.total_score ?? "-") : "-";
          },
          "/results"
        );
      }
      if (user!.role === "manager") {
        await add(
          "แบบประเมินตนเองของลูกทีมที่รออนุมัติ",
          async () => {
            const team = await list("/team");
            const all = await Promise.all(team.map((m) => list(`/employees/${m.id}/evaluations`)));
            return all.flat().filter((e) => e.type === "self" && e.status === "submitted").length;
          },
          "/approvals"
        );
      }
      if (user!.role === "hr") {
        await add(
          "แบบประเมินที่รออนุมัติ",
          async () => (await list("/reports/evaluations", { status: "submitted", limit: 500 })).length,
          "/hr/evaluations"
        );
        await add("ผู้ใช้ทั้งหมด", async () => (await list("/users")).length, "/users");
      }
      if (user!.role === "executive") {
        await add("โบนัสรออนุมัติ", async () => (await list("/executive/bonuses", { status: "pending_approval" })).length, "/executive/dashboard");
        await add("เลื่อนตำแหน่งรออนุมัติ", async () => (await list("/executive/promotions", { status: "pending_approval" })).length, "/executive/proposals");
        await add("โอนย้ายรออนุมัติ", async () => (await list("/executive/transfers", { status: "pending_approval" })).length, "/executive/proposals");
      }
      setStats(out);
    }
    load();
  }, [user]);

  if (!user) return null;
  const shortcuts = NAV_ITEMS.filter((n) => n.to !== "/" && n.roles.includes(user.role));

  return (
    <div style={{ maxWidth: 900 }}>
      <h1>สวัสดี {user.name}</h1>
      <p>
        บทบาท: {ROLE_LABEL[user.role]} · แผนก: {user.department || "-"} · ตำแหน่ง: {user.position || "-"}
      </p>

      {stats.length > 0 && (
        <>
          <h3>สรุปของคุณ</h3>
          <ul>
            {stats.map((s) => (
              <li key={s.label}>
                {s.to ? <Link to={s.to}>{s.label}</Link> : s.label}: <strong>{s.value}</strong>
              </li>
            ))}
          </ul>
        </>
      )}

      <h3>ทางลัด</h3>
      <ul>
        {shortcuts.map((n) => (
          <li key={n.to}>
            <Link to={n.to}>{n.label}</Link>
          </li>
        ))}
      </ul>
    </div>
  );
}