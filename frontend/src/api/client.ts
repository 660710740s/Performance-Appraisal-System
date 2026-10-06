import axios from "axios";

const client = axios.create({
  baseURL: "http://localhost:8080/api/v1",
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
    if (err.response?.status === 401) {
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
    return err.response?.data?.error ?? "เกิดข้อผิดพลาด กรุณาลองใหม่";
  }
  return "เกิดข้อผิดพลาด กรุณาลองใหม่";
}
