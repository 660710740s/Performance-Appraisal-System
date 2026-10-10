package handler

import (
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
	"performance/backend/internal/domain"
	"performance/backend/internal/middleware"
	"performance/backend/internal/pkg/response"
	"performance/backend/internal/service"
)

type EvaluationHandler struct{ svc *service.EvaluationService }

func NewEvaluationHandler(s *service.EvaluationService) *EvaluationHandler {
	return &EvaluationHandler{svc: s}
}

// ---- Cycle ----
type createCycleRequest struct {
	Name      string    `json:"name" binding:"required"`
	StartDate time.Time `json:"start_date" binding:"required"`
	EndDate   time.Time `json:"end_date" binding:"required"`
}

func (h *EvaluationHandler) CreateCycle(c *gin.Context) {
	var req createCycleRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		response.BadRequest(c, err)
		return
	}
	cycle := &domain.EvaluationCycle{Name: req.Name, StartDate: req.StartDate, EndDate: req.EndDate}
	if err := h.svc.CreateCycle(middleware.UserID(c), cycle); err != nil {
		response.Error(c, err)
		return
	}
	response.Created(c, cycle)
}

func (h *EvaluationHandler) ListCycles(c *gin.Context) {
	out, err := h.svc.ListCycles()
	if err != nil {
		response.Error(c, err)
		return
	}
	response.OK(c, out)
}

// ---- Criteria ----
type createCriteriaRequest struct {
	Name        string  `json:"name" binding:"required"`
	Description string  `json:"description"`
	Weight      float64 `json:"weight" binding:"required,gt=0"`
	Rubric      string  `json:"rubric"`
	Department  string  `json:"department"`
	Level       string  `json:"level"`
}

func (h *EvaluationHandler) CreateCriteria(c *gin.Context) {
	var req createCriteriaRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		response.BadRequest(c, err)
		return
	}
	cr := &domain.Criteria{Name: req.Name, Description: req.Description, Weight: req.Weight, Rubric: req.Rubric, Department: req.Department, Level: req.Level}
	if err := h.svc.CreateCriteria(middleware.UserID(c), middleware.UserRole(c), cr); err != nil {
		response.Error(c, err)
		return
	}
	response.Created(c, cr)
}

func (h *EvaluationHandler) ListCriteria(c *gin.Context) {
	empID, _ := strconv.ParseUint(c.Query("employee_id"), 10, 64)
	out, err := h.svc.ListCriteriaForUser(middleware.UserID(c), middleware.UserRole(c), uint(empID))
	if err != nil {
		response.Error(c, err)
		return
	}
	response.OK(c, out)
}

type updateCycleRequest struct {
	Name      string    `json:"name" binding:"required"`
	StartDate time.Time `json:"start_date" binding:"required"`
	EndDate   time.Time `json:"end_date" binding:"required"`
	Status    string    `json:"status" binding:"omitempty,oneof=open closed"`
}

func (h *EvaluationHandler) UpdateCycle(c *gin.Context) {
	id, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		response.BadRequest(c, err)
		return
	}
	var req updateCycleRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		response.BadRequest(c, err)
		return
	}
	out, err := h.svc.UpdateCycle(middleware.UserID(c), uint(id), service.UpdateCycleInput{
		Name: req.Name, StartDate: req.StartDate, EndDate: req.EndDate, Status: req.Status,
	})
	if err != nil {
		response.Error(c, err)
		return
	}
	response.OK(c, out)
}

type updateCriteriaRequest struct {
	Name        string  `json:"name" binding:"required"`
	Description string  `json:"description"`
	Weight      float64 `json:"weight" binding:"required,gt=0"`
	IsActive    *bool   `json:"is_active" binding:"required"`
	Rubric      *string `json:"rubric"`
	Department  *string `json:"department"`
	Level       *string `json:"level"`
}

func (h *EvaluationHandler) UpdateCriteria(c *gin.Context) {
	id, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		response.BadRequest(c, err)
		return
	}
	var req updateCriteriaRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		response.BadRequest(c, err)
		return
	}
	out, err := h.svc.UpdateCriteria(uint(id), service.UpdateCriteriaInput{
		Name: req.Name, Description: req.Description, Weight: req.Weight, IsActive: *req.IsActive, Rubric: req.Rubric, Department: req.Department, Level: req.Level,
	})
	if err != nil {
		response.Error(c, err)
		return
	}
	response.OK(c, out)
}

// ---- Evaluation ----
type scoreRequest struct {
	CriteriaID uint   `json:"criteria_id" binding:"required"`
	Score      int    `json:"score" binding:"required,min=1,max=5"`
	Comment    string `json:"comment"`
}

type createEvaluationRequest struct {
	CycleID    uint           `json:"cycle_id" binding:"required"`
	EmployeeID uint           `json:"employee_id" binding:"required"`
	Type       string         `json:"type" binding:"omitempty,oneof=self supervisor"`
	Comment    string         `json:"comment"`
	Scores     []scoreRequest `json:"scores" binding:"required,min=1,dive"`
}

func toScoreInputs(in []scoreRequest) []service.ScoreInput {
	out := make([]service.ScoreInput, 0, len(in))
	for _, s := range in {
		out = append(out, service.ScoreInput{CriteriaID: s.CriteriaID, Score: s.Score, Comment: s.Comment})
	}
	return out
}

func (h *EvaluationHandler) Create(c *gin.Context) {
	var req createEvaluationRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		response.BadRequest(c, err)
		return
	}
	e, err := h.svc.Create(middleware.UserID(c), middleware.UserRole(c), service.CreateEvaluationInput{
		CycleID: req.CycleID, EmployeeID: req.EmployeeID, Type: req.Type, Comment: req.Comment, Scores: toScoreInputs(req.Scores),
	})
	if err != nil {
		response.Error(c, err)
		return
	}
	response.Created(c, e)
}

// แก้ไขแบบประเมินที่ยังเป็น draft หรือถูกตีกลับ
type updateEvaluationRequest struct {
	Comment string         `json:"comment"`
	Scores  []scoreRequest `json:"scores" binding:"required,min=1,dive"`
}

func (h *EvaluationHandler) UpdateDraft(c *gin.Context) {
	id, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		response.BadRequest(c, err)
		return
	}
	var req updateEvaluationRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		response.BadRequest(c, err)
		return
	}
	e, err := h.svc.UpdateDraft(uint(id), middleware.UserID(c), service.UpdateEvaluationInput{
		Comment: req.Comment, Scores: toScoreInputs(req.Scores),
	})
	if err != nil {
		response.Error(c, err)
		return
	}
	response.OK(c, e)
}

func (h *EvaluationHandler) Submit(c *gin.Context) {
	id, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		response.BadRequest(c, err)
		return
	}
	e, err := h.svc.Submit(uint(id), middleware.UserID(c), middleware.UserRole(c))
	if err != nil {
		response.Error(c, err)
		return
	}
	response.OK(c, e)
}

type feedbackRequest struct {
	Feedback string `json:"feedback" binding:"required"`
}

type rejectRequest struct {
	Reason string `json:"reason" binding:"required"`
}

func (h *EvaluationHandler) Approve(c *gin.Context) {
	id, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		response.BadRequest(c, err)
		return
	}
	e, err := h.svc.Approve(uint(id), middleware.UserID(c), middleware.UserRole(c))
	if err != nil {
		response.Error(c, err)
		return
	}
	response.OK(c, e)
}

// ตีกลับให้ผู้ประเมินแก้ไข (ต้องระบุเหตุผล)
func (h *EvaluationHandler) Reject(c *gin.Context) {
	id, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		response.BadRequest(c, err)
		return
	}
	var req rejectRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		response.BadRequest(c, err)
		return
	}
	e, err := h.svc.Reject(uint(id), middleware.UserID(c), middleware.UserRole(c), req.Reason)
	if err != nil {
		response.Error(c, err)
		return
	}
	response.OK(c, e)
}

func (h *EvaluationHandler) AddFeedback(c *gin.Context) {
	id, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		response.BadRequest(c, err)
		return
	}
	var req feedbackRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		response.BadRequest(c, err)
		return
	}
	e, err := h.svc.AddFeedback(uint(id), middleware.UserID(c), req.Feedback)
	if err != nil {
		response.Error(c, err)
		return
	}
	response.OK(c, e)
}

func (h *EvaluationHandler) Get(c *gin.Context) {
	id, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		response.BadRequest(c, err)
		return
	}
	e, err := h.svc.Get(uint(id), middleware.UserID(c), middleware.UserRole(c))
	if err != nil {
		response.Error(c, err)
		return
	}
	response.OK(c, e)
}

// ผลประเมินของฉัน (เห็นเฉพาะที่ submit แล้ว)
func (h *EvaluationHandler) ListMine(c *gin.Context) {
	out, err := h.svc.ListMine(middleware.UserID(c))
	if err != nil {
		response.Error(c, err)
		return
	}
	response.OK(c, out)
}

// ที่ฉันเป็นผู้ประเมิน (รวม self-evaluation ของตัวเอง)
func (h *EvaluationHandler) ListGiven(c *gin.Context) {
	out, err := h.svc.ListGiven(middleware.UserID(c))
	if err != nil {
		response.Error(c, err)
		return
	}
	response.OK(c, out)
}

func (h *EvaluationHandler) ListDepartments(c *gin.Context) {
	out, err := h.svc.ListDepartments()
	if err != nil {
		response.Error(c, err)
		return
	}
	response.OK(c, out)
}

func (h *EvaluationHandler) ListLevels(c *gin.Context) {
	out, err := h.svc.ListLevels()
	if err != nil {
		response.Error(c, err)
		return
	}
	response.OK(c, out)
}
func (h *EvaluationHandler) ListPositions(c *gin.Context) {
	out, err := h.svc.ListPositions()
	if err != nil {
		response.Error(c, err)
		return
	}
	response.OK(c, out)
}
