export type Role = "admin" | "manager" | "employee";

export interface User {
  id: number;
  employee_code: string;
  name: string;
  email: string;
  role: Role;
  department: string;
  position: string;
  manager_id: number | null;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export interface Cycle {
  id: number;
  name: string;
  start_date: string;
  end_date: string;
}

export interface Criteria {
  id: number;
  name: string;
  description: string;
  weight: number;
}

export interface Score {
  criteria_id: number;
  score: number;
  comment: string;
}

export interface Evaluation {
  id: number;
  cycle_id: number;
  employee_id: number;
  evaluator_id?: number;
  comment: string;
  status?: string;
  scores: Score[];
}

export interface ApiError {
  error: string;
}
