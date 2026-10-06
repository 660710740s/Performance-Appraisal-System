import { NavLink, Outlet } from "react-router-dom";
import { useAuth } from "../context/AuthContext";

export default function Layout() {
  const { user, logout } = useAuth();

  const links = [
    { to: "/", label: "หน้าหลัก", roles: ["admin", "manager", "employee"] },
    { to: "/evaluations", label: "งานประเมิน", roles: ["admin", "manager", "employee"] },
    { to: "/users", label: "ผู้ใช้งาน", roles: ["admin"] },
    { to: "/cycles", label: "รอบประเมิน", roles: ["admin"] },
    { to: "/criteria", label: "เกณฑ์ประเมิน", roles: ["admin"] },
  ];

  const visibleLinks = links.filter((l) => user && l.roles.includes(user.role));

  return (
    <div className="app-shell">
      <header className="topbar">
        <div className="brand">Performance Appraisal</div>
        <div className="user-info">
          <span>{user?.name} ({user?.role})</span>
          <button onClick={logout} className="btn-ghost">ออกจากระบบ</button>
        </div>
      </header>

      <div className="body">
        <nav className="sidenav">
          {visibleLinks.map((l) => (
            <NavLink key={l.to} to={l.to} end={l.to === "/"} className={({ isActive }) => isActive ? "nav-link active" : "nav-link"}>
              {l.label}
            </NavLink>
          ))}
        </nav>

        <main className="content">
          <Outlet />
        </main>
      </div>

      <nav className="bottomnav">
        {visibleLinks.map((l) => (
          <NavLink key={l.to} to={l.to} end={l.to === "/"} className={({ isActive }) => isActive ? "bn-link active" : "bn-link"}>
            {l.label}
          </NavLink>
        ))}
      </nav>
    </div>
  );
}
