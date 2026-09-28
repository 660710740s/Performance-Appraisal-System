package response

import (
	"errors"
	"net/http"

	"github.com/gin-gonic/gin"
	"performance/backend/internal/domain"
)

func OK(c *gin.Context, data interface{}) {
	c.JSON(http.StatusOK, gin.H{"data": data})
}

func Created(c *gin.Context, data interface{}) {
	c.JSON(http.StatusCreated, gin.H{"data": data})
}

func Error(c *gin.Context, err error) {
	status := http.StatusInternalServerError
	switch {
	case errors.Is(err, domain.ErrNotFound):
		status = http.StatusNotFound
	case errors.Is(err, domain.ErrUnauthorized):
		status = http.StatusUnauthorized
	case errors.Is(err, domain.ErrForbidden):
		status = http.StatusForbidden
	case errors.Is(err, domain.ErrInvalidInput):
		status = http.StatusBadRequest
	case errors.Is(err, domain.ErrConflict):
		status = http.StatusConflict
	}
	c.JSON(status, gin.H{"error": err.Error()})
}

func BadRequest(c *gin.Context, err error) {
	c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
}
