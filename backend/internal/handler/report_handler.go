package handler

import (
	"github.com/gin-gonic/gin"
	"performance/backend/internal/pkg/response"
	"performance/backend/internal/service"
)

type ReportHandler struct{ svc *service.ReportService }

func NewReportHandler(s *service.ReportService) *ReportHandler {
	return &ReportHandler{svc: s}
}

// GET ?cycle_id= (ไม่ส่ง = ทุกรอบ)
func (h *ReportHandler) Summary(c *gin.Context) {
	cycleID, ok := parseOptionalUint(c, "cycle_id")
	if !ok {
		return
	}
	out, err := h.svc.Summary(cycleID)
	if err != nil {
		response.Error(c, err)
		return
	}
	response.OK(c, out)
}
