package handler

import (
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
	"performance/backend/internal/middleware"
	"performance/backend/internal/pkg/response"
	"performance/backend/internal/service"
)

type AccountingHandler struct{ svc *service.AccountingService }

func NewAccountingHandler(s *service.AccountingService) *AccountingHandler {
	return &AccountingHandler{svc: s}
}

func parseIDParam(c *gin.Context, name string) (uint, bool) {
	v, err := strconv.ParseUint(c.Param(name), 10, 64)
	if err != nil {
		response.BadRequest(c, err)
		return 0, false
	}
	return uint(v), true
}

func parseOptionalUint(c *gin.Context, name string) (uint, bool) {
	s := c.Query(name)
	if s == "" {
		return 0, true
	}
	v, err := strconv.ParseUint(s, 10, 64)
	if err != nil {
		response.BadRequest(c, err)
		return 0, false
	}
	return uint(v), true
}

// ---- Salary ----
type setSalaryRequest struct {
	EmployeeID    uint      `json:"employee_id" binding:"required"`
	Amount        float64   `json:"amount" binding:"required,gt=0"`
	EffectiveDate time.Time `json:"effective_date" binding:"required"`
}

func (h *AccountingHandler) SetSalary(c *gin.Context) {
	var req setSalaryRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		response.BadRequest(c, err)
		return
	}
	out, err := h.svc.SetSalary(middleware.UserID(c), service.SetSalaryInput{
		EmployeeID: req.EmployeeID, Amount: req.Amount, EffectiveDate: req.EffectiveDate,
	})
	if err != nil {
		response.Error(c, err)
		return
	}
	response.Created(c, out)
}

func (h *AccountingHandler) ListCurrentSalaries(c *gin.Context) {
	out, err := h.svc.ListCurrentSalaries()
	if err != nil {
		response.Error(c, err)
		return
	}
	response.OK(c, out)
}

func (h *AccountingHandler) SalaryHistory(c *gin.Context) {
	id, ok := parseIDParam(c, "employee_id")
	if !ok {
		return
	}
	out, err := h.svc.SalaryHistory(id)
	if err != nil {
		response.Error(c, err)
		return
	}
	response.OK(c, out)
}

// ---- Bonus ----
type createBonusRequest struct {
	EvaluationID uint     `json:"evaluation_id" binding:"required"`
	Amount       *float64 `json:"amount" binding:"omitempty,gte=0"` // ไม่ส่ง = ใช้ยอดที่ระบบเสนอ
	Note         string   `json:"note"`
}

type updateBonusRequest struct {
	Amount *float64 `json:"amount" binding:"required,gte=0"`
	Note   string   `json:"note"`
}

type decisionRequest struct {
	Note string `json:"note"`
}

func (h *AccountingHandler) Candidates(c *gin.Context) {
	cycleID, ok := parseOptionalUint(c, "cycle_id")
	if !ok {
		return
	}
	if cycleID == 0 {
		response.BadRequest(c, strconv.ErrSyntax)
		return
	}
	out, err := h.svc.Candidates(cycleID)
	if err != nil {
		response.Error(c, err)
		return
	}
	response.OK(c, out)
}

func (h *AccountingHandler) ListBonuses(c *gin.Context) {
	cycleID, ok := parseOptionalUint(c, "cycle_id")
	if !ok {
		return
	}
	out, err := h.svc.ListBonuses(cycleID, c.Query("status"))
	if err != nil {
		response.Error(c, err)
		return
	}
	response.OK(c, out)
}

func (h *AccountingHandler) CreateBonus(c *gin.Context) {
	var req createBonusRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		response.BadRequest(c, err)
		return
	}
	out, err := h.svc.CreateBonus(middleware.UserID(c), req.EvaluationID, req.Amount, req.Note)
	if err != nil {
		response.Error(c, err)
		return
	}
	response.Created(c, out)
}

func (h *AccountingHandler) UpdateBonus(c *gin.Context) {
	id, ok := parseIDParam(c, "id")
	if !ok {
		return
	}
	var req updateBonusRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		response.BadRequest(c, err)
		return
	}
	out, err := h.svc.UpdateBonus(middleware.UserID(c), id, *req.Amount, req.Note)
	if err != nil {
		response.Error(c, err)
		return
	}
	response.OK(c, out)
}

func (h *AccountingHandler) decide(c *gin.Context, approve bool) {
	id, ok := parseIDParam(c, "id")
	if !ok {
		return
	}
	var req decisionRequest
	_ = c.ShouldBindJSON(&req) // note ไม่บังคับ
	out, err := h.svc.Decide(middleware.UserID(c), id, approve, req.Note)
	if err != nil {
		response.Error(c, err)
		return
	}
	response.OK(c, out)
}

func (h *AccountingHandler) Approve(c *gin.Context) { h.decide(c, true) }
func (h *AccountingHandler) Reject(c *gin.Context)  { h.decide(c, false) }
