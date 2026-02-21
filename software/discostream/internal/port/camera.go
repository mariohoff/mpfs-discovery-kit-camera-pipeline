package port

type Camera interface {
	Init() error
	Reset() error
	Close() error
}
