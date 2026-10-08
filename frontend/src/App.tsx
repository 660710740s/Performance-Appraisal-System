import { BrowserRouter, Routes, Route } from "react-router-dom";
import { AuthProvider } from "./context/AuthContext";
import ProtectedRoute from "./components/ProtectedRoute";
import RoleRoute from "./components/RoleRoute";
import Layout from "./components/Layout";
import LoginPage from "./pages/LoginPage";
import DashboardPage from "./pages/DashboardPage";
import EmployeeEvaluationPage from "./pages/EmployeeEvaluationPage";
import SupervisorApprovalsPage from "./pages/SupervisorApprovalsPage";
import HREvaluationsPage from "./pages/HREvaluationsPage";
import HRUsersPage from "./pages/HRUsersPage";
import HRCyclesPage from "./pages/HRCyclesPage";
import HRCriteriaPage from "./pages/HRCriteriaPage";
import AccountingBonusPage from "./pages/AccountingBonusPage";
import ExecutiveDashboardPage from "./pages/ExecutiveDashboardPage";
import ReportsPage from "./pages/ReportsPage";

export default function App() {
  return (
    <BrowserRouter>
      <AuthProvider>
        <Routes>
          <Route path="/login" element={<LoginPage />} />
          <Route element={<ProtectedRoute />}>
            <Route element={<Layout />}>
              <Route path="/" element={<DashboardPage />} />

              <Route element={<RoleRoute roles={["employee", "manager"]} />}>
                <Route path="/evaluations/self" element={<EmployeeEvaluationPage />} />
              </Route>

              <Route element={<RoleRoute roles={["manager"]} />}>
                <Route path="/approvals" element={<SupervisorApprovalsPage />} />
              </Route>

              <Route element={<RoleRoute roles={["hr"]} />}>
                <Route path="/hr/evaluations" element={<HREvaluationsPage />} />
                <Route path="/users" element={<HRUsersPage />} />
                <Route path="/cycles" element={<HRCyclesPage />} />
                <Route path="/criteria" element={<HRCriteriaPage />} />
              </Route>

              <Route element={<RoleRoute roles={["accounting"]} />}>
                <Route path="/accounting/bonus" element={<AccountingBonusPage />} />
              </Route>

              <Route element={<RoleRoute roles={["executive"]} />}>
                <Route path="/executive/dashboard" element={<ExecutiveDashboardPage />} />
              </Route>

              <Route element={<RoleRoute roles={["hr", "executive"]} />}>
                <Route path="/reports" element={<ReportsPage />} />
              </Route>
            </Route>
          </Route>
        </Routes>
      </AuthProvider>
    </BrowserRouter>
  );
}