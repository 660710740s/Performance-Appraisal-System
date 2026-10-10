import "../redesign.css";
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

const ROLE_COLORS: Record<Role, string> = {
  employee: "#2563eb",
  manager: "#7c3aed",
  hr: "#0891b2",
  accounting: "#0f766e",
  executive: "#c2410c",
};

const list = async (path: string, params?: Record<string, string | number>) => {
  const res = await client.get(path, { params });
  return (res.data.data ?? []) as Record<string, unknown>[];
};

const cardIcons = ["▦", "✓", "◷", "↗", "◎", "▤"];

export default function DashboardPage() {
  const { user } = useAuth();
  const [stats, setStats] = useState<Stat[]>([]);
  const [loadingStats, setLoadingStats] = useState(false);

  useEffect(() => {
    if (!user) return;
    let cancelled = false;

    async function load() {
      setLoadingStats(true);
      const out: Stat[] = [];
      const add = async (
        label: string,
        fn: () => Promise<number | string>,
        to?: string
      ) => {
        try {
          out.push({ label, value: await fn(), to });
        } catch {
          // ข้ามรายการที่โหลดไม่ได้ เพื่อให้ข้อมูลส่วนอื่นยังแสดงได้
        }
      };

      if (user!.role === "employee" || user!.role === "manager") {
        await add(
          "ผลประเมินของฉัน",
          async () => (await list("/evaluations/me")).length,
          "/results"
        );
        await add(
          "คะแนนล่าสุดจากหัวหน้า",
          async () => {
            const evaluations = await list("/evaluations/me");
            const approved = evaluations.filter(
              (item) =>
                item.type === "supervisor" && item.status === "approved"
            );
            const last = approved[approved.length - 1];
            return last ? String(last.total_score ?? "-") : "-";
          },
          "/results"
        );
      }

      if (user!.role === "manager") {
        await add(
          "แบบประเมินที่รออนุมัติ",
          async () => {
            const team = await list("/team");
            const all = await Promise.all(
              team.map((member) => list(`/employees/${member.id}/evaluations`))
            );
            return all
              .flat()
              .filter(
                (item) =>
                  item.type === "self" && item.status === "submitted"
              ).length;
          },
          "/approvals"
        );
      }

      if (user!.role === "hr") {
        await add(
          "แบบประเมินที่รออนุมัติ",
          async () =>
            (
              await list("/reports/evaluations", {
                status: "submitted",
                limit: 500,
              })
            ).length,
          "/hr/evaluations"
        );
        await add("ผู้ใช้ทั้งหมด", async () => (await list("/users")).length, "/users");
      }

      if (user!.role === "executive") {
        await add(
          "โบนัสรออนุมัติ",
          async () =>
            (
              await list("/executive/bonuses", {
                status: "pending_approval",
              })
            ).length,
          "/executive/dashboard"
        );
        await add(
          "เลื่อนตำแหน่งรออนุมัติ",
          async () =>
            (
              await list("/executive/promotions", {
                status: "pending_approval",
              })
            ).length,
          "/executive/proposals"
        );
        await add(
          "โอนย้ายรออนุมัติ",
          async () =>
            (
              await list("/executive/transfers", {
                status: "pending_approval",
              })
            ).length,
          "/executive/proposals"
        );
      }

      if (!cancelled) {
        setStats(out);
        setLoadingStats(false);
      }
    }

    void load();
    return () => {
      cancelled = true;
    };
  }, [user]);

  if (!user) return null;

  const shortcuts = NAV_ITEMS.filter(
    (item) => item.to !== "/" && item.roles.includes(user.role)
  );
  const roleColor = ROLE_COLORS[user.role] ?? "#2563eb";
  const now = new Date();
  const dateLabel = new Intl.DateTimeFormat("th-TH", {
    weekday: "long",
    day: "numeric",
    month: "long",
    year: "numeric",
  }).format(now);

  const styles = {
    page: {
      width: "100%",
      maxWidth: 1240,
      margin: "0 auto",
      color: "#172033",
      fontFamily:
        'Inter, "Noto Sans Thai", "Leelawadee UI", system-ui, sans-serif',
    } as const,
    muted: { color: "#667085" } as const,
    panel: {
      background: "#fff",
      border: "1px solid #e7ebf2",
      borderRadius: 18,
      boxShadow: "0 4px 18px rgba(16, 24, 40, 0.035)",
    } as const,
  };

  return (
    <main style={styles.page}>
      <style>{`
        .hr-dashboard-link {
          color: inherit;
          text-decoration: none;
        }
        .hr-dashboard-link:focus-visible {
          outline: 3px solid #93c5fd;
          outline-offset: 3px;
          border-radius: 12px;
        }
        .hr-shortcut {
          display: flex;
          align-items: center;
          gap: 12px;
          min-height: 68px;
          padding: 14px;
          border: 1px solid #e7ebf2;
          border-radius: 14px;
          background: #fff;
          transition: transform .16s ease, box-shadow .16s ease, border-color .16s ease;
        }
        .hr-shortcut:hover {
          transform: translateY(-2px);
          border-color: #bfd4ff;
          box-shadow: 0 8px 22px rgba(37, 99, 235, .09);
        }
        .hr-stat {
          min-width: 0;
          display: flex;
          gap: 14px;
          align-items: flex-start;
          padding: 20px;
          border: 1px solid #e7ebf2;
          border-radius: 16px;
          background: #fff;
          box-shadow: 0 4px 18px rgba(16, 24, 40, .035);
          transition: transform .16s ease, box-shadow .16s ease;
        }
        .hr-stat:hover {
          transform: translateY(-2px);
          box-shadow: 0 9px 24px rgba(16, 24, 40, .07);
        }
        @media (max-width: 640px) {
          .hr-dashboard-hero { padding: 22px !important; }
          .hr-dashboard-heading { font-size: 24px !important; }
          .hr-stat { padding: 15px; }
        }
      `}</style>

      <header
        className="hr-dashboard-hero"
        style={{
          display: "flex",
          flexWrap: "wrap",
          alignItems: "center",
          justifyContent: "space-between",
          gap: 22,
          padding: "30px 32px",
          borderRadius: 22,
          color: "#fff",
          background:
            "radial-gradient(circle at 88% 15%, rgba(255,255,255,.20), transparent 28%), linear-gradient(120deg, #123b86 0%, #2563eb 58%, #4388f5 100%)",
          boxShadow: "0 14px 35px rgba(37, 99, 235, .18)",
          marginBottom: 26,
        }}
      >
        <div style={{ minWidth: 220, flex: "1 1 300px" }}>
          <div
            style={{
              display: "inline-flex",
              alignItems: "center",
              gap: 8,
              borderRadius: 999,
              padding: "6px 11px",
              background: "rgba(255,255,255,.14)",
              fontSize: 12,
              fontWeight: 700,
              letterSpacing: ".04em",
              marginBottom: 14,
            }}
          >
            <span
              style={{
                width: 7,
                height: 7,
                borderRadius: "50%",
                background: "#86efac",
              }}
            />
            HR WORKSPACE
          </div>
          <h1
            className="hr-dashboard-heading"
            style={{
              margin: "0 0 9px",
              fontSize: 30,
              lineHeight: 1.25,
              letterSpacing: "-.025em",
            }}
          >
            สวัสดี, {user.name}
          </h1>
          <p style={{ margin: 0, color: "#e1eaff", lineHeight: 1.8 }}>
            ยินดีต้อนรับกลับเข้าสู่ระบบจัดการและประเมินผลบุคลากร
          </p>
        </div>
        <div
          style={{
            minWidth: 190,
            padding: "15px 18px",
            border: "1px solid rgba(255,255,255,.22)",
            borderRadius: 15,
            background: "rgba(255,255,255,.12)",
            backdropFilter: "blur(8px)",
          }}
        >
          <div style={{ color: "#dbeafe", fontSize: 12, marginBottom: 7 }}>
            วันนี้
          </div>
          <div style={{ fontSize: 15, fontWeight: 700 }}>{dateLabel}</div>
          <div style={{ marginTop: 12, fontSize: 12, color: "#dbeafe" }}>
            บัญชีผู้ใช้: {ROLE_LABEL[user.role]}
          </div>
        </div>
      </header>

      <section
        style={{
          display: "flex",
          flexWrap: "wrap",
          justifyContent: "space-between",
          alignItems: "end",
          gap: 12,
          marginBottom: 14,
        }}
      >
        <div>
          <h2 style={{ fontSize: 19, margin: "0 0 5px", fontWeight: 800 }}>
            ภาพรวมของคุณ
          </h2>
          <p style={{ ...styles.muted, margin: 0, fontSize: 13 }}>
            สรุปข้อมูลสำคัญตามสิทธิ์การใช้งานของบัญชี
          </p>
        </div>
        <div
          style={{
            borderRadius: 999,
            background: "#f0f5ff",
            color: roleColor,
            padding: "7px 12px",
            fontSize: 12,
            fontWeight: 700,
          }}
        >
          {ROLE_LABEL[user.role]}
        </div>
      </section>

      <section
        aria-label="สรุปข้อมูล"
        style={{
          display: "grid",
          gridTemplateColumns: "repeat(auto-fit, minmax(min(100%, 235px), 1fr))",
          gap: 14,
          marginBottom: 30,
        }}
      >
        {loadingStats && stats.length === 0 ? (
          <div style={{ ...styles.panel, padding: 22, color: "#667085" }}>
            กำลังโหลดข้อมูลสรุป...
          </div>
        ) : stats.length > 0 ? (
          stats.map((stat, index) => {
            const content = (
              <div className="hr-stat" style={{ height: "100%", boxSizing: "border-box" }}>
                <div
                  aria-hidden="true"
                  style={{
                    display: "grid",
                    placeItems: "center",
                    flex: "0 0 44px",
                    height: 44,
                    borderRadius: 13,
                    color: roleColor,
                    background: `${roleColor}14`,
                    fontSize: 23,
                    fontWeight: 800,
                  }}
                >
                  {cardIcons[index % cardIcons.length]}
                </div>
                <div style={{ minWidth: 0 }}>
                  <div
                    style={{
                      fontSize: 12,
                      lineHeight: 1.6,
                      color: "#667085",
                      marginBottom: 7,
                    }}
                  >
                    {stat.label}
                  </div>
                  <div style={{ fontSize: 28, fontWeight: 800, lineHeight: 1.2 }}>
                    {stat.value}
                  </div>
                  <div style={{ fontSize: 11, color: roleColor, marginTop: 8 }}>
                    ดูรายละเอียด <span aria-hidden="true">→</span>
                  </div>
                </div>
              </div>
            );
            return stat.to ? (
              <Link
                key={stat.label}
                to={stat.to}
                className="hr-dashboard-link"
                aria-label={`ดูรายละเอียด ${stat.label}`}
              >
                {content}
              </Link>
            ) : (
              <div key={stat.label}>{content}</div>
            );
          })
        ) : (
          <div
            style={{
              ...styles.panel,
              padding: 22,
              gridColumn: "1 / -1",
              color: "#667085",
              fontSize: 14,
            }}
          >
            ยังไม่มีข้อมูลสรุปสำหรับบัญชีนี้ หรือไม่สามารถโหลดข้อมูลจากระบบได้
          </div>
        )}
      </section>

      <section
        style={{
          ...styles.panel,
          padding: 24,
          marginBottom: 22,
        }}
      >
        <div
          style={{
            display: "flex",
            flexWrap: "wrap",
            alignItems: "center",
            justifyContent: "space-between",
            gap: 12,
            marginBottom: 18,
          }}
        >
          <div>
            <h2 style={{ margin: "0 0 5px", fontSize: 19, fontWeight: 800 }}>
              เมนูทางลัด
            </h2>
            <p style={{ ...styles.muted, margin: 0, fontSize: 13 }}>
              เลือกเมนูเพื่อเข้าสู่การทำงานที่คุณได้รับอนุญาต
            </p>
          </div>
          <span style={{ fontSize: 12, color: "#667085" }}>
            {shortcuts.length} เมนู
          </span>
        </div>

        {shortcuts.length > 0 ? (
          <div
            style={{
              display: "grid",
              gridTemplateColumns: "repeat(auto-fit, minmax(min(100%, 230px), 1fr))",
              gap: 12,
            }}
          >
            {shortcuts.map((item, index) => (
              <Link
                key={item.to}
                to={item.to}
                className="hr-dashboard-link hr-shortcut"
              >
                <span
                  aria-hidden="true"
                  style={{
                    display: "grid",
                    placeItems: "center",
                    flex: "0 0 40px",
                    width: 40,
                    height: 40,
                    borderRadius: 12,
                    background: "#edf4ff",
                    color: "#2563eb",
                    fontSize: 20,
                    fontWeight: 800,
                  }}
                >
                  {["▦", "♙", "✓", "◷", "▤", "◎"][index % 6]}
                </span>
                <span style={{ flex: 1, minWidth: 0 }}>
                  <span
                    style={{
                      display: "block",
                      fontWeight: 700,
                      fontSize: 13,
                      marginBottom: 4,
                    }}
                  >
                    {item.label}
                  </span>
                  <span style={{ display: "block", color: "#667085", fontSize: 11 }}>
                    เปิดหน้าการทำงาน
                  </span>
                </span>
                <span aria-hidden="true" style={{ color: "#98a2b3", fontSize: 20 }}>
                  ›
                </span>
              </Link>
            ))}
          </div>
        ) : (
          <p style={{ ...styles.muted, margin: 0, fontSize: 14 }}>
            ไม่มีเมนูเพิ่มเติมสำหรับสิทธิ์การใช้งานนี้
          </p>
        )}
      </section>

      <section
        style={{
          display: "flex",
          flexWrap: "wrap",
          alignItems: "center",
          gap: 10,
          padding: "16px 18px",
          borderRadius: 14,
          background: "#f8fafc",
          border: "1px solid #e7ebf2",
        }}
      >
        <span
          aria-hidden="true"
          style={{
            display: "grid",
            placeItems: "center",
            width: 34,
            height: 34,
            borderRadius: 10,
            background: "#e8f7ee",
            color: "#15803d",
            fontWeight: 800,
          }}
        >
          ✓
        </span>
        <div style={{ flex: 1, minWidth: 200 }}>
          <div style={{ fontSize: 13, fontWeight: 700 }}>ข้อมูลบัญชีของคุณ</div>
          <div style={{ fontSize: 12, color: "#667085", marginTop: 4 }}>
            แผนก: {user.department || "-"} · ตำแหน่ง: {user.position || "-"}
          </div>
        </div>
        <span
          style={{
            color: "#15803d",
            background: "#e8f7ee",
            padding: "6px 10px",
            borderRadius: 999,
            fontSize: 11,
            fontWeight: 700,
          }}
        >
          บัญชีใช้งาน
        </span>
      </section>
    </main>
  );
}
