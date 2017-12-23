blue-green: main.go
	CGO_ENABLED=0 go build

clean:
	go clean

.PHONY: clean
