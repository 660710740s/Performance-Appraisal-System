import { useAuth } from "../context/AuthContext";

export default function DashboardPage() {
  const { user } = useAuth();
  return (
    <div>
      <h1>สวัสดี, {user?.name}</h1>
      <p>บทบาท: {user?.role} · แผนก: {user?.department}</p>
      <div className="card-grid">
        <div className="card">
          <h3>งานประเมิน</h3>
          <p>ดูและจัดการงานประเมินของคุณได้ที่เมนู "งานประเมิน"</p>
        </div>
      </div>
    </div>
  );
}
