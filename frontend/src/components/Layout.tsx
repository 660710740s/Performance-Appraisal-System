import { NavLink, Outlet } from "react-router-dom";
import { useAuth } from "../context/AuthContext";
import { NAV_ITEMS } from "../config/navigation";

export default function Layout() {
  const { user, logout } = useAuth();

  const visibleLinks = NAV_ITEMS.filter((l) => user && l.roles.includes(user.role));

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