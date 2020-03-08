.PHONY: containers test clean

blue-green: main.go
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build

containers: blue-green
	docker build . --build-arg COLOUR=blue -t mtinside/blue-green:blue
	docker build . --build-arg COLOUR=green -t mtinside/blue-green:green
	docker build . --build-arg COLOUR=orange -t mtinside/blue-green:orange
	docker build . --build-arg COLOUR=purple -t mtinside/blue-green:purple
	docker build . --build-arg COLOUR=red -t mtinside/blue-green:red

test: containers
	docker run -d --rm --name blue -p 8080 mtinside/blue-green:blue
	docker run -d --rm --name green -p 8080 mtinside/blue-green:green
	docker run -d --rm --name orange -p 8080 mtinside/blue-green:orange
	docker run -d --rm --name purple -p 8080 mtinside/blue-green:purple
	docker run -d --rm --name red -p 8080 mtinside/blue-green:red

push: containers
	docker push mtinside/blue-green

clean:
	go clean
