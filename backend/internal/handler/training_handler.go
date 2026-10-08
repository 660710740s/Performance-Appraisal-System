package handler

import (
	"time"

	"github.com/gin-gonic/gin"
	"performance/backend/internal/middleware"
	"performance/backend/internal/pkg/response"
	"performance/backend/internal/service"
)

type TrainingHandler struct{ svc *service.TrainingService }

func NewTrainingHandler(s *service.TrainingService) *TrainingHandler {
	return &TrainingHandler{svc: s}
}

type createTrainingRequest struct {
	EvaluationID uint       `json:"evaluation_id" binding:"required"`
	Topic        string     `json:"topic" binding:"required,max=255"`
	Reason       string     `json:"reason"`
	StartDate    *time.Time `json:"start_date"`
	EndDate      *time.Time `json:"end_date"`
}

type updateTrainingRequest struct {
	Topic     string     `json:"topic" binding:"required,max=255"`
	Reason    string     `json:"reason"`
	StartDate *time.Time `json:"start_date"`
	EndDate   *time.Time `json:"end_date"`
}

type trainingStatusRequest struct {
	Status string `json:"status" binding:"required"`
}

func (h *TrainingHandler) Create(c *gin.Context) {
	var req createTrainingRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		response.BadRequest(c, err)
		return
	}
	out, err := h.svc.Create(middleware.UserID(c), middleware.UserRole(c), service.TrainingInput{
		EvaluationID: req.EvaluationID, Topic: req.Topic, Reason: req.Reason,
		StartDate: req.StartDate, EndDate: req.EndDate,
	})
	if err != nil {
		response.Error(c, err)
		return
	}
	response.Created(c, out)
}

func (h *TrainingHandler) Update(c *gin.Context) {
	id, ok := parseIDParam(c, "id")
	if !ok {
		return
	}
	var req updateTrainingRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		response.BadRequest(c, err)
		return
	}
	out, err := h.svc.Update(middleware.UserID(c), middleware.UserRole(c), id, service.TrainingInput{
		Topic: req.Topic, Reason: req.Reason, StartDate: req.StartDate, EndDate: req.EndDate,
	})
	if err != nil {
		response.Error(c, err)
		return
	}
	response.OK(c, out)
}

func (h *TrainingHandler) UpdateStatus(c *gin.Context) {
	id, ok := parseIDParam(c, "id")
	if !ok {
		return
	}
	var req trainingStatusRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		response.BadRequest(c, err)
		return
	}
	out, err := h.svc.UpdateStatus(middleware.UserID(c), middleware.UserRole(c), id, req.Status)
	if err != nil {
		response.Error(c, err)
		return
	}
	response.OK(c, out)
}

// GET ?employee_id=&evaluation_id=&status=
func (h *TrainingHandler) List(c *gin.Context) {
	employeeID, ok := parseOptionalUint(c, "employee_id")
	if !ok {
		return
	}
	evaluationID, ok := parseOptionalUint(c, "evaluation_id")
	if !ok {
		return
	}
	out, err := h.svc.List(middleware.UserID(c), middleware.UserRole(c), employeeID, evaluationID, c.Query("status"))
	if err != nil {
		response.Error(c, err)
		return
	}
	response.OK(c, out)
}
