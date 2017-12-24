blue-green: main.go
	CGO_ENABLED=0 go build

containers: blue-green
	docker build . --file Dockerfile.blue -t mtinside/blue-green:blue
	docker build . --file Dockerfile.green -t mtinside/blue-green:green
	docker build . --file Dockerfile.orange -t mtinside/blue-green:orange
	docker build . --file Dockerfile.purple -t mtinside/blue-green:purple
	docker build . --file Dockerfile.red -t mtinside/blue-green:red

test: containers
	docker run -d --rm --name blue -p 8080 mtinside/blue-green:blue
	docker run -d --rm --name green -p 8080 mtinside/blue-green:green
	docker run -d --rm --name orange -p 8080 mtinside/blue-green:orange
	docker run -d --rm --name purple -p 8080 mtinside/blue-green:purple
	docker run -d --rm --name red -p 8080 mtinside/blue-green:red

clean:
	go clean

.PHONY: containers test clean
