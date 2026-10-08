package main

import (
	"log"
	"time"

	"performance/backend/configs"
	"performance/backend/internal/handler"
	"performance/backend/internal/repository"
	"performance/backend/internal/service"
)

func main() {
	cfg := configs.Load()

	db, err := repository.NewDB(cfg.DSN())
	if err != nil {
		log.Fatalf("cannot connect to database: %v", err)
	}
	sqlDB, _ := db.DB()
	defer sqlDB.Close()
	log.Println("connected to database")

	// repositories
	userRepo := repository.NewUserRepository(db)
	evalRepo := repository.NewEvaluationRepository(db)
	accRepo := repository.NewAccountingRepository(db)
	reportRepo := repository.NewReportRepository(db)
	promoRepo := repository.NewPromotionRepository(db)
	transferRepo := repository.NewTransferRepository(db)

	// services
	authSvc := service.NewAuthService(userRepo, cfg.JWTSecret, 24*time.Hour)
	userSvc := service.NewUserService(userRepo)
	evalSvc := service.NewEvaluationService(evalRepo, userRepo)
	accSvc := service.NewAccountingService(accRepo, evalRepo, userRepo)
	reportSvc := service.NewReportService(reportRepo, evalRepo, accRepo)
	promoSvc := service.NewPromotionService(promoRepo, evalRepo, userRepo)
	transferSvc := service.NewTransferService(transferRepo, evalRepo, userRepo)

	// handlers
	authHandler := handler.NewAuthHandler(authSvc, userSvc)
	userHandler := handler.NewUserHandler(userSvc)
	evalHandler := handler.NewEvaluationHandler(evalSvc)
	accHandler := handler.NewAccountingHandler(accSvc)
	reportHandler := handler.NewReportHandler(reportSvc)
	promoHandler := handler.NewPromotionHandler(promoSvc)
	transferHandler := handler.NewTransferHandler(transferSvc)

	// router
	r := handler.SetupRouter(cfg.JWTSecret, authHandler, userHandler, evalHandler, accHandler, reportHandler, promoHandler, transferHandler)

	log.Printf("server running on :%s", cfg.ServerPort)
	if err := r.Run(":" + cfg.ServerPort); err != nil {
		log.Fatal(err)
	}
}
