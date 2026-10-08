package domain

type TransferRepository interface {
	CreateTransfer(t *TransferRequest) error
	GetTransfer(id uint) (*TransferRequest, error)
	GetTransferByEvaluation(evaluationID uint) (*TransferRequest, error)
	UpdateTransfer(t *TransferRequest) error
	ListTransfers(cycleID uint, status string) ([]TransferRequest, error)
}
