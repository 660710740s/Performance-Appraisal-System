import axios from "axios";

const client = axios.create({
  baseURL: "/api/v1",
});

client.interceptors.request.use((config) => {
  const token = localStorage.getItem("token");
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

client.interceptors.response.use(
  (res) => res,
  (err) => {
    // 401 ตอนล็อกอินคือรหัสผ่านผิด ไม่ต้องเด้งออก เพื่อให้หน้า login แสดงข้อความได้
    const isLogin = err.config?.url?.includes("/auth/login");
    if (err.response?.status === 401 && !isLogin) {
      localStorage.removeItem("token");
      localStorage.removeItem("user");
      window.location.href = "/login";
    }
    return Promise.reject(err);
  }
);

export default client;

export function errorMessage(err: unknown): string {
  if (axios.isAxiosError(err)) {
    switch (err.response?.status) {
      case 400: return "ข้อมูลไม่ถูกต้อง กรุณาตรวจสอบอีกครั้ง";
      case 401: return "อีเมลหรือรหัสผ่านไม่ถูกต้อง";
      case 403: return "คุณไม่มีสิทธิ์ทำรายการนี้";
      case 404: return "ไม่พบข้อมูลที่ต้องการ";
      case 409: return "รายการนี้ถูกดำเนินการไปแล้วหรือซ้ำกับรายการเดิม";
      default: return "เกิดข้อผิดพลาด กรุณาลองใหม่";
    }
  }
  return "เกิดข้อผิดพลาด กรุณาลองใหม่";
}