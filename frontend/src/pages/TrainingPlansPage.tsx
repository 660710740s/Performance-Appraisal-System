import "../redesign.css";
import {
  useCallback,
  useEffect,
  useMemo,
  useState,
  type FormEvent,
} from "react";
import client, { errorMessage } from "../api/client";
import { useAuth } from "../context/AuthContext";

type PlanStatus = "planned" | "in_progress" | "completed" | "cancelled";

interface Plan {
  id: number;
  evaluation_id: number;
  employee_id: number;
  topic: string;
  reason: string;
  start_date: string | null;
  end_date: string | null;
  status: PlanStatus;
}

interface EvalOpt {
  id: number;
  employee_id: number;
  employee_name: string;
  cycle_name: string;
  total_score?: number | null;
}

interface HistoryItem {
  id: number;
  cycle_name: string;
  type: "self" | "supervisor";
  status: string;
}

interface ScoreItem {
  id?: number;
  criteria_id: number;
  score: number;
  comment?: string | null;
  metric?: string | number | null;
  detail?: string | null;
}

interface CriteriaItem {
  id: number;
  name: string;
  description?: string;
}

interface EvaluationDetail {
  id: number;
  employee_id: number;
  type: string;
  status: string;
  total_score?: number | null;
  scores?: ScoreItem[];
}

interface EvaluationInsight {
  loading: boolean;
  error?: string;
  totalScore?: number | null;
  needs: Array<{
    criteriaId: number;
    name: string;
    score: number;
    comment: string;
  }>;
}

const DEVELOPMENT_SCORE_THRESHOLD = 3;

const STATUS_LABEL: Record<PlanStatus, string> = {
  planned: "วางแผนไว้",
  in_progress: "กำลังดำเนินการ",
  completed: "เสร็จสิ้น",
  cancelled: "ยกเลิก",
};

const NEXT: Record<PlanStatus, PlanStatus[]> = {
  planned: ["in_progress", "cancelled"],
  in_progress: ["completed", "cancelled"],
  completed: [],
  cancelled: [],
};

const validDate = (iso: string | null | undefined) =>
  iso && !iso.startsWith("0001") ? iso.slice(0, 10) : "";

const formatScore = (score?: number | null) =>
  typeof score === "number" ? score.toFixed(2) : "ยังไม่มีคะแนน";

export default function TrainingPlansPage() {
  const { user } = useAuth();
  const canManage = user?.role === "manager" || user?.role === "hr";

  const [plans, setPlans] = useState<Plan[]>([]);
  const [opts, setOpts] = useState<EvalOpt[]>([]);
  const [editingId, setEditingId] = useState<number | null>(null);
  const [selectedEvaluationIds, setSelectedEvaluationIds] = useState<number[]>(
    []
  );
  const [expandedIds, setExpandedIds] = useState<number[]>([]);
  const [insights, setInsights] = useState<Record<number, EvaluationInsight>>(
    {}
  );

  const [search, setSearch] = useState("");
  const [cycleFilter, setCycleFilter] = useState("all");
  const [needsOnly, setNeedsOnly] = useState(true);
  const [criteriaFilter, setCriteriaFilter] = useState("all");
  const [scanningScores, setScanningScores] = useState(false);
  const [scoresScanned, setScoresScanned] = useState(false);

  const [topic, setTopic] = useState("");
  const [reason, setReason] = useState("");
  const [startDate, setStartDate] = useState("");
  const [endDate, setEndDate] = useState("");
  const [error, setError] = useState("");
  const [info, setInfo] = useState("");
  const [busy, setBusy] = useState(false);
  const [loadingEvaluations, setLoadingEvaluations] = useState(false);

  const loadPlans = useCallback(async () => {
    try {
      const res = await client.get("/training-plans");
      setPlans(res.data.data ?? []);
    } catch (err) {
      setError(errorMessage(err));
    }
  }, []);

  useEffect(() => {
    void loadPlans();
  }, [loadPlans]);

  // โหลดผลประเมินที่หัวหน้าอนุมัติแล้ว
  useEffect(() => {
    let active = true;

    async function loadOptions() {
      setLoadingEvaluations(true);
      setError("");

      try {
        let options: EvalOpt[] = [];

        if (user?.role === "hr") {
          const res = await client.get("/reports/evaluations", {
            params: {
              status: "approved",
              type: "supervisor",
              limit: 500,
            },
          });

          options = (res.data.data ?? []).map((row: EvalOpt) => ({
            id: row.id,
            employee_id: row.employee_id,
            employee_name: row.employee_name,
            cycle_name: row.cycle_name,
            total_score: row.total_score,
          }));
        } else if (user?.role === "manager") {
          const teamRes = await client.get("/team");
          const members: Array<{ id: number; name: string }> =
            teamRes.data.data ?? [];

          const results = await Promise.all(
            members.map(async (member) => {
              const res = await client.get(
                `/employees/${member.id}/evaluations`
              );
              const history: HistoryItem[] = res.data.data ?? [];

              return history
                .filter(
                  (item) =>
                    item.type === "supervisor" &&
                    item.status === "approved"
                )
                .map((item) => ({
                  id: item.id,
                  employee_id: member.id,
                  employee_name: member.name,
                  cycle_name: item.cycle_name,
                }));
            })
          );

          options = results.flat();
        }

        if (active) {
          const unique = new Map<number, EvalOpt>();
          options.forEach((option) => unique.set(option.id, option));

          setOpts(Array.from(unique.values()));
        }
      } catch (err) {
        if (active) setError(errorMessage(err));
      } finally {
        if (active) setLoadingEvaluations(false);
      }
    }

    if (canManage) {
      void loadOptions();
    } else {
      setLoadingEvaluations(false);
    }

    return () => {
      active = false;
    };
  }, [canManage, user?.role]);

  const cycles = useMemo(
    () =>
      Array.from(
        new Set(opts.map((option) => option.cycle_name).filter(Boolean))
      ).sort((a, b) => a.localeCompare(b)),
    [opts]
  );

  // สร้างรายการหัวข้อที่พบว่าต้องพัฒนาสำหรับ dropdown
  const developmentCriteria = useMemo(() => {
    const unique = new Map<number, string>();

    Object.values(insights).forEach((insight) => {
      if (insight.error || insight.loading) return;

      insight.needs.forEach((item) => {
        unique.set(item.criteriaId, item.name);
      });
    });

    return Array.from(unique.entries())
      .map(([id, name]) => ({ id, name }))
      .sort((a, b) => a.name.localeCompare(b.name));
  }, [insights]);

  // กรองด้วยชื่อพนักงาน รอบประเมิน และจุดที่ต้องพัฒนา
  const filteredOptions = useMemo(() => {
    const keyword = search.trim().toLowerCase();

    return opts.filter((option) => {
      const matchesSearch =
        !keyword ||
        option.employee_name.toLowerCase().includes(keyword) ||
        option.cycle_name.toLowerCase().includes(keyword) ||
        String(option.employee_id).includes(keyword);

      const matchesCycle =
        cycleFilter === "all" || option.cycle_name === cycleFilter;

      const insight = insights[option.id];

      const hasDevelopmentNeeds =
        insight !== undefined &&
        !insight.loading &&
        !insight.error &&
        insight.needs.length > 0;

      const matchesNeeds = !needsOnly || hasDevelopmentNeeds;

      const matchesCriteria =
        criteriaFilter === "all" ||
        (insight !== undefined &&
          !insight.loading &&
          !insight.error &&
          insight.needs.some(
            (item) => String(item.criteriaId) === criteriaFilter
          ));

      return (
        matchesSearch &&
        matchesCycle &&
        matchesNeeds &&
        matchesCriteria
      );
    });
  }, [
    opts,
    search,
    cycleFilter,
    needsOnly,
    criteriaFilter,
    insights,
  ]);

  const nameOf = (id: number) =>
    opts.find((option) => option.employee_id === id)?.employee_name ??
    (id === user?.id ? user.name : `พนักงาน #${id}`);

  function resetForm() {
    setEditingId(null);
    setSelectedEvaluationIds([]);
    setTopic("");
    setReason("");
    setStartDate("");
    setEndDate("");
    setError("");
  }

  function toggleEvaluation(id: number) {
    setSelectedEvaluationIds((current) =>
      current.includes(id)
        ? current.filter((selectedId) => selectedId !== id)
        : [...current, id]
    );
  }

  function selectAllFiltered() {
    setSelectedEvaluationIds((current) =>
      Array.from(
        new Set([...current, ...filteredOptions.map((option) => option.id)])
      )
    );
  }

  function clearSelection() {
    setSelectedEvaluationIds([]);
  }

  // ตรวจคะแนนแยกทีละหัวข้อ ไม่ใช้คะแนนรวมตัดสิน
  async function getEvaluationInsight(
    option: EvalOpt
  ): Promise<EvaluationInsight> {
    const [evaluationRes, criteriaRes] = await Promise.all([
      client.get(`/evaluations/${option.id}`),
      client.get("/criteria", {
        params: { employee_id: option.employee_id },
      }),
    ]);

    const evaluation: EvaluationDetail =
      evaluationRes.data.data ?? evaluationRes.data;

    const criteria: CriteriaItem[] = criteriaRes.data.data ?? [];

    const criteriaMap = new Map(
      criteria.map((item) => [item.id, item])
    );

    // คะแนนรายหัวข้อที่ต่ำกว่า 3/5 เป็นจุดที่ควรพัฒนา
    // คะแนนรวมสูงก็ยังต้องแสดงพนักงานคนนี้
    const needs = (evaluation.scores ?? [])
      .filter(
        (score) =>
          typeof score.score === "number" &&
          score.score > 0 &&
          score.score < DEVELOPMENT_SCORE_THRESHOLD
      )
      .map((score) => {
        // metric อาจเป็นตัวเลข เช่น 0 จึงต้องแปลงอย่างปลอดภัย
        // และไม่แสดง 0 เป็นรายละเอียด
        const metricText =
          score.metric !== undefined &&
          score.metric !== null &&
          score.metric !== 0 &&
          score.metric !== "0"
            ? String(score.metric).trim()
            : "";

        const commentText =
          typeof score.comment === "string"
            ? score.comment.trim()
            : "";

        const detailText =
          typeof score.detail === "string"
            ? score.detail.trim()
            : "";

        return {
          criteriaId: score.criteria_id,
          name:
            criteriaMap.get(score.criteria_id)?.name ??
            `หัวข้อประเมิน #${score.criteria_id}`,
          score: score.score,
          comment: commentText || detailText || metricText,
        };
      })
      .sort((a, b) => a.score - b.score);

    return {
      loading: false,
      totalScore: evaluation.total_score ?? null,
      needs,
    };
  }

  async function toggleDetails(option: EvalOpt) {
    const id = option.id;

    if (expandedIds.includes(id)) {
      setExpandedIds((current) => current.filter((item) => item !== id));
      return;
    }

    setExpandedIds((current) => [...current, id]);

    if (insights[id] && !insights[id].error) return;

    setInsights((current) => ({
      ...current,
      [id]: { loading: true, needs: [] },
    }));

    try {
      const insight = await getEvaluationInsight(option);

      setInsights((current) => ({
        ...current,
        [id]: insight,
      }));
    } catch (err) {
      setInsights((current) => ({
        ...current,
        [id]: {
          loading: false,
          needs: [],
          error: errorMessage(err),
        },
      }));
    }
  }

  // ตรวจผลประเมินทั้งหมดโดยอัตโนมัติเมื่อโหลดรายการเสร็จ
  async function scanAllEvaluations() {
    if (scanningScores || opts.length === 0) return;

    setScanningScores(true);
    setError("");
    setInfo("กำลังตรวจคะแนนรายหัวข้ออัตโนมัติ...");

    let successCount = 0;
    let errorCount = 0;

    try {
      // จำกัด request พร้อมกันครั้งละ 6 รายการ
      for (let start = 0; start < opts.length; start += 6) {
        const batch = opts.slice(start, start + 6);

        const results = await Promise.all(
          batch.map(async (option) => {
            try {
              const insight = await getEvaluationInsight(option);
              return { id: option.id, insight };
            } catch (err) {
              return {
                id: option.id,
                insight: {
                  loading: false,
                  needs: [],
                  error: errorMessage(err),
                } satisfies EvaluationInsight,
              };
            }
          })
        );

        const batchInsights: Record<number, EvaluationInsight> = {};

        results.forEach(({ id, insight }) => {
          batchInsights[id] = insight;

          if (insight.error) errorCount++;
          else successCount++;
        });

        setInsights((current) => ({
          ...current,
          ...batchInsights,
        }));
      }

      setScoresScanned(true);
      setInfo(
        `ตรวจคะแนนเสร็จแล้ว ${successCount} รายการ` +
          (errorCount > 0
            ? ` · ตรวจไม่สำเร็จ ${errorCount} รายการ`
            : "")
      );
    } catch (err) {
      setError(errorMessage(err));
      setInfo("");
    } finally {
      setScanningScores(false);
    }
  }

  // เรียกตรวจคะแนนอัตโนมัติเมื่อผลประเมินโหลดครบ
  useEffect(() => {
    if (
      !loadingEvaluations &&
      opts.length > 0 &&
      !scoresScanned &&
      !scanningScores
    ) {
      void scanAllEvaluations();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [opts, loadingEvaluations, scoresScanned]);

  function startEdit(plan: Plan) {
    setError("");
    setInfo("");
    setEditingId(plan.id);
    setSelectedEvaluationIds([]);
    setTopic(plan.topic);
    setReason(plan.reason ?? "");
    setStartDate(validDate(plan.start_date));
    setEndDate(validDate(plan.end_date));
  }

  async function submit(event: FormEvent) {
    event.preventDefault();
    setError("");
    setInfo("");

    if (!topic.trim()) {
      setError("กรุณากรอกหัวข้อการฝึกอบรม");
      return;
    }

    if (editingId === null && selectedEvaluationIds.length === 0) {
      setError("กรุณาเลือกผลประเมินอย่างน้อย 1 รายการ");
      return;
    }

    if (startDate && endDate && endDate < startDate) {
      setError("วันสิ้นสุดต้องไม่ก่อนวันเริ่ม");
      return;
    }

    const body: Record<string, unknown> = {
      topic: topic.trim(),
      reason: reason.trim(),
    };

    if (startDate) body.start_date = `${startDate}T00:00:00Z`;
    if (endDate) body.end_date = `${endDate}T00:00:00Z`;

    setBusy(true);

    try {
      if (editingId !== null) {
        await client.put(`/training-plans/${editingId}`, body);
        setInfo("แก้ไขแผนฝึกอบรมแล้ว");
        resetForm();
        await loadPlans();
        return;
      }

      const results = await Promise.allSettled(
        selectedEvaluationIds.map((evaluationId) =>
          client.post("/training-plans", {
            ...body,
            evaluation_id: evaluationId,
          })
        )
      );

      const successCount = results.filter(
        (result) => result.status === "fulfilled"
      ).length;

      const failed = results.filter(
        (result) => result.status === "rejected"
      );

      if (failed.length > 0) {
        setInfo(
          successCount > 0
            ? `สร้างสำเร็จ ${successCount} รายการ`
            : ""
        );

        setError(
          `สร้างไม่สำเร็จ ${failed.length} รายการ: ${errorMessage(
            failed[0].status === "rejected"
              ? failed[0].reason
              : new Error("เกิดข้อผิดพลาด")
          )}`
        );

        await loadPlans();
        return;
      }

      setInfo(`สร้างแผนฝึกอบรมสำเร็จ ${successCount} รายการ`);
      resetForm();
      await loadPlans();
    } catch (err) {
      setError(errorMessage(err));
    } finally {
      setBusy(false);
    }
  }

  async function changeStatus(plan: Plan, status: PlanStatus) {
    setError("");
    setInfo("");
    setBusy(true);

    try {
      await client.patch(`/training-plans/${plan.id}/status`, { status });
      setInfo("เปลี่ยนสถานะแผนแล้ว");
      await loadPlans();
    } catch (err) {
      setError(errorMessage(err));
    } finally {
      setBusy(false);
    }
  }

  return (
    <div style={{ maxWidth: 1100, margin: "0 auto" }}>
      <h1>แผนฝึกอบรม</h1>

      <p style={{ color: "#64748b", marginTop: -8 }}>
        ใช้ผลประเมินจากหัวหน้าที่ได้รับอนุมัติแล้ว เพื่อวางแผนพัฒนาทักษะพนักงาน
      </p>

      {error && <div className="error-box">{error}</div>}
      {info && <p role="status">{info}</p>}

      {canManage && (
        <form
          onSubmit={submit}
          style={{
            display: "grid",
            gap: 14,
            margin: "20px 0 28px",
          }}
        >
          <section
            style={{
              padding: 18,
              border: "1px solid #dbe3ec",
              borderRadius: 12,
              background: "#fff",
            }}
          >
            <h3 style={{ marginTop: 0 }}>
              {editingId !== null
                ? "แก้ไขแผนฝึกอบรม"
                : "1. เลือกพนักงานที่ต้องการพัฒนา"}
            </h3>

            {editingId === null && (
              <>
                <div
                  style={{
                    display: "grid",
                    gridTemplateColumns: "repeat(auto-fit, minmax(220px, 1fr))",
                    gap: 10,
                    marginBottom: 12,
                  }}
                >
                  <label>
                    ค้นหาพนักงาน / รอบประเมิน
                    <input
                      value={search}
                      onChange={(event) => setSearch(event.target.value)}
                      placeholder="ชื่อพนักงานหรือรอบประเมิน"
                      style={{ display: "block", width: "100%" }}
                      disabled={busy}
                    />
                  </label>

                  <label>
                    รอบการประเมิน
                    <select
                      value={cycleFilter}
                      onChange={(event) => setCycleFilter(event.target.value)}
                      style={{ display: "block", width: "100%" }}
                      disabled={busy}
                    >
                      <option value="all">ทุกรอบการประเมิน</option>
                      {cycles.map((cycle) => (
                        <option key={cycle} value={cycle}>
                          {cycle}
                        </option>
                      ))}
                    </select>
                  </label>
                </div>

                <div
                  style={{
                    display: "grid",
                    gridTemplateColumns: "repeat(auto-fit, minmax(220px, 1fr))",
                    gap: 10,
                    marginBottom: 12,
                  }}
                >
                  <label>
                    กรองตามจุดที่ต้องพัฒนา
                    <select
                      value={criteriaFilter}
                      onChange={(event) => setCriteriaFilter(event.target.value)}
                      style={{ display: "block", width: "100%" }}
                      disabled={busy || scanningScores}
                    >
                      <option value="all">ทุกจุดที่ต้องพัฒนา</option>
                      {developmentCriteria.map((criterion) => (
                        <option
                          key={criterion.id}
                          value={String(criterion.id)}
                        >
                          {criterion.name}
                        </option>
                      ))}
                    </select>
                  </label>

                  <label
                    style={{
                      display: "flex",
                      alignItems: "center",
                      gap: 8,
                      alignSelf: "end",
                      paddingBottom: 8,
                    }}
                  >
                    <input
                      type="checkbox"
                      checked={needsOnly}
                      onChange={(event) => setNeedsOnly(event.target.checked)}
                      disabled={busy}
                    />
                    แสดงเฉพาะพนักงานที่มีจุดต้องพัฒนา
                  </label>
                </div>

                <p style={{ color: "#64748b", fontSize: 13 }}>
                  {loadingEvaluations
                    ? "กำลังโหลดผลประเมิน..."
                    : scanningScores
                      ? "กำลังตรวจคะแนนรายหัวข้ออัตโนมัติ..."
                      : scoresScanned
                        ? "ตรวจคะแนนเสร็จแล้ว · ใช้จุดที่ต้องพัฒนาเป็นตัวคัดกรอง ไม่ใช้คะแนนรวมตัดสิน"
                        : "ระบบจะตรวจคะแนนรายหัวข้ออัตโนมัติ"}
                </p>

                <div
                  style={{
                    display: "flex",
                    flexWrap: "wrap",
                    alignItems: "center",
                    gap: 8,
                    marginBottom: 10,
                  }}
                >
                  <button
                    type="button"
                    onClick={selectAllFiltered}
                    disabled={busy || filteredOptions.length === 0}
                  >
                    เลือกรายการที่แสดง
                  </button>

                  <button
                    type="button"
                    onClick={clearSelection}
                    disabled={busy || selectedEvaluationIds.length === 0}
                  >
                    ล้างการเลือก
                  </button>

                  <span style={{ color: "#64748b", fontSize: 13 }}>
                    เลือก {selectedEvaluationIds.length} รายการ จาก{" "}
                    {filteredOptions.length} รายการที่แสดง
                  </span>
                </div>

                <div
                  style={{
                    display: "grid",
                    gap: 10,
                    maxHeight: 440,
                    overflowY: "auto",
                    padding: 4,
                  }}
                >
                  {loadingEvaluations ? (
                    <p>กำลังโหลดผลประเมิน...</p>
                  ) : scanningScores && !scoresScanned ? (
                    <p style={{ color: "#64748b" }}>
                      กำลังตรวจคะแนนรายหัวข้ออัตโนมัติ...
                    </p>
                  ) : filteredOptions.length === 0 ? (
                    <p style={{ color: "#64748b" }}>
                      {needsOnly && !scoresScanned
                        ? "กำลังเตรียมตรวจคะแนนรายหัวข้อ..."
                        : "ไม่พบพนักงานตามเงื่อนไขที่เลือก"}
                    </p>
                  ) : (
                    filteredOptions.map((option) => {
                      const insight = insights[option.id];
                      const selected = selectedEvaluationIds.includes(
                        option.id
                      );

                      return (
                        <div
                          key={option.id}
                          style={{
                            border: selected
                              ? "1px solid #64748b"
                              : "1px solid #e2e8f0",
                            borderRadius: 10,
                            padding: 12,
                            background: selected ? "#f8fafc" : "#fff",
                          }}
                        >
                          <div
                            style={{
                              display: "flex",
                              alignItems: "flex-start",
                              gap: 10,
                            }}
                          >
                            <input
                              type="checkbox"
                              checked={selected}
                              onChange={() => toggleEvaluation(option.id)}
                              disabled={busy}
                              style={{ marginTop: 4 }}
                              aria-label={`เลือกผลประเมิน ${option.employee_name}`}
                            />

                            <div style={{ flex: 1, minWidth: 0 }}>
                              <strong>{option.employee_name}</strong>

                              <div style={{ color: "#64748b", fontSize: 13 }}>
                                {option.cycle_name} · Evaluation #{option.id}
                              </div>

                              {insight &&
                                !insight.loading &&
                                !insight.error && (
                                  <div style={{ marginTop: 6, fontSize: 13 }}>
                                    คะแนนรวม:{" "}
                                    <strong>
                                      {formatScore(insight.totalScore)}
                                    </strong>
                                    {" · "}
                                    จุดที่ควรพัฒนา:{" "}
                                    <strong>{insight.needs.length} หัวข้อ</strong>
                                  </div>
                                )}

                              {insight?.error && (
                                <div
                                  style={{
                                    color: "#b91c1c",
                                    fontSize: 13,
                                  }}
                                >
                                  โหลดคะแนนไม่สำเร็จ: {insight.error}
                                </div>
                              )}
                            </div>

                            <button
                              type="button"
                              onClick={() => void toggleDetails(option)}
                              disabled={busy}
                            >
                              {expandedIds.includes(option.id)
                                ? "ซ่อนคะแนน"
                                : "ดูคะแนน"}
                            </button>
                          </div>

                          {expandedIds.includes(option.id) && (
                            <div
                              style={{
                                marginTop: 12,
                                marginLeft: 28,
                                paddingTop: 10,
                                borderTop: "1px solid #e2e8f0",
                              }}
                            >
                              {insight?.loading ? (
                                <p>กำลังโหลดรายละเอียดคะแนน...</p>
                              ) : insight?.error ? (
                                <p style={{ color: "#b91c1c" }}>
                                  โหลดคะแนนไม่สำเร็จ: {insight.error}
                                </p>
                              ) : insight ? (
                                insight.needs.length > 0 ? (
                                  <>
                                    <strong>หัวข้อที่ควรพัฒนา</strong>

                                    <ul style={{ marginBottom: 0 }}>
                                      {insight.needs.map((item) => (
                                        <li key={item.criteriaId}>
                                          <strong>{item.name}</strong>
                                          {" — "}
                                          <span style={{ color: "#b91c1c" }}>
                                            {item.score}/5
                                          </span>

                                          {item.comment && (
                                            <div
                                              style={{
                                                color: "#64748b",
                                                fontSize: 13,
                                              }}
                                            >
                                              {item.comment}
                                            </div>
                                          )}
                                        </li>
                                      ))}
                                    </ul>
                                  </>
                                ) : (
                                  <p style={{ color: "#64748b", margin: 0 }}>
                                    ไม่พบจุดที่ต้องพัฒนาในข้อมูลที่โหลดได้
                                  </p>
                                )
                              ) : (
                                <p style={{ color: "#64748b" }}>
                                  กดดูคะแนนเพื่อโหลดรายละเอียด
                                </p>
                              )}
                            </div>
                          )}
                        </div>
                      );
                    })
                  )}
                </div>
              </>
            )}
          </section>

          <section
            style={{
              padding: 18,
              border: "1px solid #dbe3ec",
              borderRadius: 12,
              background: "#fff",
            }}
          >
            <h3 style={{ marginTop: 0 }}>
              {editingId !== null
                ? "รายละเอียดแผน"
                : "2. กำหนดแผนฝึกอบรม"}
            </h3>

            <label>
              หัวข้อการฝึกอบรม *
              <input
                value={topic}
                onChange={(event) => setTopic(event.target.value)}
                placeholder="เช่น Communication Skills"
                style={{ display: "block", width: "100%" }}
                disabled={busy}
                required
              />
            </label>

            <label>
              เหตุผล / ทักษะที่ต้องการพัฒนา
              <textarea
                value={reason}
                onChange={(event) => setReason(event.target.value)}
                placeholder="ระบุทักษะที่ต้องพัฒนาและเป้าหมายหลังการฝึกอบรม"
                rows={3}
                style={{ display: "block", width: "100%" }}
                disabled={busy}
              />
            </label>

            <div
              style={{
                display: "grid",
                gridTemplateColumns: "repeat(auto-fit, minmax(180px, 1fr))",
                gap: 12,
              }}
            >
              <label>
                วันที่เริ่ม
                <input
                  type="date"
                  value={startDate}
                  onChange={(event) => setStartDate(event.target.value)}
                  style={{ display: "block", width: "100%" }}
                  disabled={busy}
                />
              </label>

              <label>
                วันที่สิ้นสุด
                <input
                  type="date"
                  value={endDate}
                  onChange={(event) => setEndDate(event.target.value)}
                  style={{ display: "block", width: "100%" }}
                  disabled={busy}
                />
              </label>
            </div>

            <div style={{ display: "flex", flexWrap: "wrap", gap: 8 }}>
              <button
                type="submit"
                className="btn-primary"
                style={{ width: "auto" }}
                disabled={
                  busy ||
                  (editingId === null && selectedEvaluationIds.length === 0)
                }
              >
                {busy
                  ? "กำลังบันทึก..."
                  : editingId !== null
                    ? "บันทึกการแก้ไข"
                    : `สร้างแผน (${selectedEvaluationIds.length} รายการ)`}
              </button>

              {editingId !== null && (
                <button type="button" onClick={resetForm} disabled={busy}>
                  ยกเลิกแก้ไข
                </button>
              )}
            </div>
          </section>
        </form>
      )}

      <section style={{ marginTop: 28 }}>
        <h2>รายการแผนฝึกอบรม</h2>

        <div style={{ overflowX: "auto" }}>
          <table style={{ width: "100%", borderCollapse: "collapse" }}>
            <thead>
              <tr style={{ textAlign: "left" }}>
                <th style={{ padding: 10 }}>พนักงาน</th>
                <th style={{ padding: 10 }}>หัวข้อ</th>
                <th style={{ padding: 10 }}>ช่วงเวลา</th>
                <th style={{ padding: 10 }}>สถานะ</th>
                {canManage && <th style={{ padding: 10 }}>จัดการ</th>}
              </tr>
            </thead>

            <tbody>
              {plans.map((plan) => (
                <tr key={plan.id} style={{ borderTop: "1px solid #e2e8f0" }}>
                  <td style={{ padding: 10 }}>
                    {nameOf(plan.employee_id)}
                    <div style={{ color: "#64748b", fontSize: 12 }}>
                      Evaluation #{plan.evaluation_id}
                    </div>
                  </td>

                  <td style={{ padding: 10 }}>
                    <strong>{plan.topic}</strong>

                    {plan.reason && (
                      <div
                        style={{
                          color: "#64748b",
                          fontSize: 13,
                          marginTop: 4,
                        }}
                      >
                        {plan.reason}
                      </div>
                    )}
                  </td>

                  <td style={{ padding: 10 }}>
                    {validDate(plan.start_date) || "-"} ถึง{" "}
                    {validDate(plan.end_date) || "-"}
                  </td>

                  <td style={{ padding: 10 }}>
                    {STATUS_LABEL[plan.status] ?? plan.status}
                  </td>

                  {canManage && (
                    <td style={{ padding: 10 }}>
                      {NEXT[plan.status]?.length > 0 && (
                        <>
                          <button
                            type="button"
                            disabled={busy}
                            onClick={() => startEdit(plan)}
                          >
                            แก้ไข
                          </button>{" "}
                        </>
                      )}

                      {NEXT[plan.status]?.map((nextStatus) => (
                        <button
                          key={nextStatus}
                          type="button"
                          disabled={busy}
                          onClick={() => void changeStatus(plan, nextStatus)}
                          style={{ margin: "2px" }}
                        >
                          {STATUS_LABEL[nextStatus]}
                        </button>
                      ))}
                    </td>
                  )}
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        {plans.length === 0 && <p>ยังไม่มีแผนฝึกอบรม</p>}
      </section>
    </div>
  );
}
