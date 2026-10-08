package handler

import (
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
	"performance/backend/internal/domain"
	"performance/backend/internal/pkg/response"
)

// GET /reports/evaluations?cycle_id=&status=&type=&department=&limit=&offset=
func (h *ReportHandler) ListEvaluations(c *gin.Context) {
	cycleID, ok := parseOptionalUint(c, "cycle_id")
	if !ok {
		return
	}
	limit, ok := parseOptionalUint(c, "limit")
	if !ok {
		return
	}
	offset, ok := parseOptionalUint(c, "offset")
	if !ok {
		return
	}
	out, err := h.svc.EvaluationList(domain.EvaluationFilter{
		CycleID: cycleID, Status: c.Query("status"), Type: c.Query("type"),
		Department: c.Query("department"), Limit: int(limit), Offset: int(offset),
	})
	if err != nil {
		response.Error(c, err)
		return
	}
	response.OK(c, out)
}

// GET /audit-logs?entity=&entity_id=&user_id=&limit=&offset=
func (h *ReportHandler) AuditLogs(c *gin.Context) {
	entityID, ok := parseOptionalUint(c, "entity_id")
	if !ok {
		return
	}
	userID, ok := parseOptionalUint(c, "user_id")
	if !ok {
		return
	}
	limit, ok := parseOptionalUint(c, "limit")
	if !ok {
		return
	}
	offset, ok := parseOptionalUint(c, "offset")
	if !ok {
		return
	}
	out, err := h.svc.AuditLogs(domain.AuditFilter{
		Entity: c.Query("entity"), EntityID: entityID, UserID: userID,
		Limit: int(limit), Offset: int(offset),
	})
	if err != nil {
		response.Error(c, err)
		return
	}
	response.OK(c, out)
}

// GET /reports/annual?year=2026 (ไม่ส่ง = ปีปัจจุบัน)
func (h *ReportHandler) Annual(c *gin.Context) {
	year := time.Now().Year()
	if v := c.Query("year"); v != "" {
		n, err := strconv.Atoi(v)
		if err != nil {
			response.BadRequest(c, err)
			return
		}
		year = n
	}
	out, err := h.svc.Annual(year)
	if err != nil {
		response.Error(c, err)
		return
	}
	response.OK(c, out)
}