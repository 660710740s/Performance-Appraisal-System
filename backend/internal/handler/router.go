package handler

import (
	"github.com/gin-gonic/gin"
	"performance/backend/internal/domain"
	"performance/backend/internal/middleware"
)

func SetupRouter(jwtSecret string, auth *AuthHandler, user *UserHandler, eval *EvaluationHandler) *gin.Engine {
	r := gin.Default()
	r.Use(middleware.CORS())

	r.GET("/health", func(c *gin.Context) { c.JSON(200, gin.H{"status": "ok"}) })

	api := r.Group("/api/v1")
	api.POST("/auth/login", auth.Login)

	authed := api.Group("")
	authed.Use(middleware.Auth(jwtSecret))
	{
		authed.GET("/me", auth.Me)

		// users
		authed.POST("/users", middleware.RequireRoles(domain.RoleAdmin), user.Create)
		authed.GET("/users", middleware.RequireRoles(domain.RoleAdmin), user.List)
		authed.GET("/team", middleware.RequireRoles(domain.RoleManager, domain.RoleAdmin), user.Team)

		// cycles & criteria
		authed.GET("/cycles", eval.ListCycles)
		authed.POST("/cycles", middleware.RequireRoles(domain.RoleAdmin), eval.CreateCycle)
		authed.GET("/criteria", eval.ListCriteria)
		authed.POST("/criteria", middleware.RequireRoles(domain.RoleAdmin), eval.CreateCriteria)

		// evaluations
		mgr := middleware.RequireRoles(domain.RoleManager, domain.RoleAdmin)
		authed.POST("/evaluations", mgr, eval.Create)
		authed.GET("/evaluations/me", eval.ListMine)
		authed.GET("/evaluations/given", mgr, eval.ListGiven)
		authed.GET("/evaluations/:id", eval.Get)
		authed.POST("/evaluations/:id/submit", mgr, eval.Submit)
	}
	return r
}
