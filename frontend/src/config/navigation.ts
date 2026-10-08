import type { Role } from "../types";

export interface NavItem {
  to: string;
  label: string;
  roles: Role[];
}

export const NAV_ITEMS: NavItem[] = [
  { to: "/", label: "หน้าหลัก", roles: ["employee", "manager", "hr", "accounting", "executive"] },
  { to: "/evaluations/self", label: "ประเมินตนเอง", roles: ["employee", "manager"] },
  { to: "/results", label: "ผลประเมินของฉัน", roles: ["employee", "manager"] },
  { to: "/approvals", label: "รออนุมัติ", roles: ["manager"] },
  { to: "/training", label: "แผนฝึกอบรม", roles: ["employee", "manager", "hr"] },
  { to: "/hr/evaluations", label: "แบบประเมินทั้งหมด", roles: ["hr"] },
  { to: "/hr/proposals", label: "เสนอเลื่อนตำแหน่ง/โอนย้าย", roles: ["hr"] },
  { to: "/users", label: "ผู้ใช้งาน", roles: ["hr"] },
  { to: "/cycles", label: "รอบประเมิน", roles: ["hr"] },
  { to: "/criteria", label: "เกณฑ์ประเมิน", roles: ["hr"] },
  { to: "/audit", label: "Audit log", roles: ["hr"] },
  { to: "/accounting/bonus", label: "เงินเดือน/โบนัส", roles: ["accounting"] },
  { to: "/executive/dashboard", label: "แดชบอร์ดผู้บริหาร", roles: ["executive"] },
  { to: "/executive/proposals", label: "อนุมัติเลื่อนตำแหน่ง/โอนย้าย", roles: ["executive"] },
  { to: "/reports", label: "รายงานสรุปผล", roles: ["hr", "executive"] },
];