package handler

import (
	"strconv"

	"github.com/gin-gonic/gin"
	"performance/backend/internal/middleware"
	"performance/backend/internal/pkg/response"
)

// พรีวิวคะแนน auto ของตัวเองในรอบที่เลือก
func (h *EvaluationHandler) KpiPreview(c *gin.Context) {
	cycleID, err := strconv.ParseUint(c.Query("cycle_id"), 10, 64)
	if err != nil {
		response.BadRequest(c, err)
		return
	}
	out, err := h.svc.KpiPreview(middleware.UserID(c), uint(cycleID))
	if err != nil {
		response.Error(c, err)
		return
	}
	response.OK(c, out)
}
