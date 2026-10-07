package repository

import (
	"errors"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"

	"performance/backend/internal/domain"
)

func NewDB(dsn string) (*gorm.DB, error) {
        db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{
                TranslateError: true,
        })
        if err != nil {
                return nil, err
        }
        sqlDB, err := db.DB()
        if err != nil {
                return nil, err
        }
        if err := sqlDB.Ping(); err != nil {
                return nil, err
        }

        // เพิ่มตรงนี้
        if err := db.AutoMigrate(
                &domain.User{},
                &domain.EvaluationCycle{},
                &domain.Criteria{},
                &domain.Evaluation{},
                &domain.EvaluationScore{},
		&domain.AuditLog{},
        ); err != nil {
                return nil, err
        }

        return db, nil
}

func mapErr(err error) error {
	switch {
	case errors.Is(err, gorm.ErrRecordNotFound):
		return domain.ErrNotFound
	case errors.Is(err, gorm.ErrDuplicatedKey):
		return domain.ErrConflict
	default:
		return err
	}
}