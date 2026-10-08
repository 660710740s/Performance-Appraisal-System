package handler

import (
	"time"

	"github.com/gin-gonic/gin"
	"performance/backend/internal/middleware"
	"performance/backend/internal/pkg/response"
	"performance/backend/internal/service"
)

type TransferHandler struct{ svc *service.TransferService }

func NewTransferHandler(s *service.TransferService) *TransferHandler {
	return &TransferHandler{svc: s}
}

type createTransferRequest struct {
	EvaluationID  uint       `json:"evaluation_id" binding:"required"`
	ToDepartment  string     `json:"to_department" binding:"required,max=100"`
	EffectiveDate *time.Time `json:"effective_date"`
	Note          string     `json:"note"`
}

func (h *TransferHandler) Create(c *gin.Context) {
	var req createTransferRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		response.BadRequest(c, err)
		return
	}
	out, err := h.svc.Create(middleware.UserID(c), service.CreateTransferInput{
		EvaluationID: req.EvaluationID, ToDepartment: req.ToDepartment,
		EffectiveDate: req.EffectiveDate, Note: req.Note,
	})
	if err != nil {
		response.Error(c, err)
		return
	}
	response.Created(c, out)
}

// GET ?cycle_id=&status=
func (h *TransferHandler) List(c *gin.Context) {
	cycleID, ok := parseOptionalUint(c, "cycle_id")
	if !ok {
		return
	}
	out, err := h.svc.List(cycleID, c.Query("status"))
	if err != nil {
		response.Error(c, err)
		return
	}
	response.OK(c, out)
}

func (h *TransferHandler) decide(c *gin.Context, approve bool) {
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

func (h *TransferHandler) Approve(c *gin.Context) { h.decide(c, true) }
func (h *TransferHandler) Reject(c *gin.Context)  { h.decide(c, false) }
