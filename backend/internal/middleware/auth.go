package middleware

import (
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
	"performance/backend/internal/domain"
	"performance/backend/internal/pkg/jwtutil"
)

const (
	CtxUserID = "user_id"
	CtxRole   = "role"
)

func Auth(secret string) gin.HandlerFunc {
	return func(c *gin.Context) {
		h := c.GetHeader("Authorization")
		if !strings.HasPrefix(h, "Bearer ") {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "missing token"})
			return
		}
		claims, err := jwtutil.Parse(secret, strings.TrimPrefix(h, "Bearer "))
		if err != nil {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "invalid token"})
			return
		}
		c.Set(CtxUserID, claims.UserID)
		c.Set(CtxRole, domain.Role(claims.Role))
		c.Next()
	}
}

func RequireRoles(roles ...domain.Role) gin.HandlerFunc {
	return func(c *gin.Context) {
		role, _ := c.Get(CtxRole)
		for _, r := range roles {
			if role == r {
				c.Next()
				return
			}
		}
		c.AbortWithStatusJSON(http.StatusForbidden, gin.H{"error": "forbidden"})
	}
}

func UserID(c *gin.Context) uint { return c.GetUint(CtxUserID) }

func UserRole(c *gin.Context) domain.Role {
	r, _ := c.Get(CtxRole)
	role, _ := r.(domain.Role)
	return role
}
