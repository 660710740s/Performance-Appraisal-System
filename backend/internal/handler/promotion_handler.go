package handler

import (
	"github.com/gin-gonic/gin"
	"performance/backend/internal/middleware"
	"performance/backend/internal/pkg/response"
	"performance/backend/internal/service"
)

type PromotionHandler struct{ svc *service.PromotionService }

func NewPromotionHandler(s *service.PromotionService) *PromotionHandler {
	return &PromotionHandler{svc: s}
}

type createPromotionRequest struct {
	EvaluationID uint   `json:"evaluation_id" binding:"required"`
	ToPosition   string `json:"to_position" binding:"required,max=100"`
	ToLevel      string `json:"to_level" binding:"max=50"`
	Note         string `json:"note"`
}

func (h *PromotionHandler) Create(c *gin.Context) {
	var req createPromotionRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		response.BadRequest(c, err)
		return
	}
	out, err := h.svc.Create(middleware.UserID(c), service.CreatePromotionInput{
		EvaluationID: req.EvaluationID, ToPosition: req.ToPosition, ToLevel: req.ToLevel, Note: req.Note,
	})
	if err != nil {
		response.Error(c, err)
		return
	}
	response.Created(c, out)
}

// GET ?cycle_id=&status=
func (h *PromotionHandler) List(c *gin.Context) {
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

func (h *PromotionHandler) decide(c *gin.Context, approve bool) {
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

func (h *PromotionHandler) Approve(c *gin.Context) { h.decide(c, true) }
func (h *PromotionHandler) Reject(c *gin.Context)  { h.decide(c, false) }
