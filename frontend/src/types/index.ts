export type Role = "employee" | "manager" | "hr" | "accounting" | "executive";

export interface User {
  id: number;
  employee_code: string;
  name: string;
  email: string;
  role: Role;
  department: string;
  position: string;
  level?: string;
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
  status?: "open" | "closed";
}

export interface Criteria {
  id: number;
  name: string;
  description: string;
  weight: number;
  rubric?: string;
  department?: string;
  level?: string;
  is_active?: boolean;
}

export interface Department {
  id: number;
  name: string;
}

export interface Level {
  id: number;
  name: string;
  sort_order: number;
}

export interface Score {
  criteria_id: number;
  score: number;
  comment: string;
}

export type EvaluationStatus = "draft" | "submitted" | "approved" | "rejected";

export interface Evaluation {
  id: number;
  cycle_id: number;
  employee_id: number;
  type: "self" | "supervisor";
  evaluator_id?: number;
  status: EvaluationStatus;
  total_score?: number;
  comment: string;
  employee_feedback?: string;
  scores: Score[];
}

export interface ApiError {
  error: string;
}

export interface Position {
  id: number;
  name: string;
}