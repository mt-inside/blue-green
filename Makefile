.PHONY: containers test clean

build-local:
	cargo build

run:
	COLOUR=blue cargo run

containers:
	docker build . --build-arg COLOUR=blue -t mtinside/blue-green:blue
	docker build . --build-arg COLOUR=green -t mtinside/blue-green:green
	docker build . --build-arg COLOUR=orange -t mtinside/blue-green:orange
	docker build . --build-arg COLOUR=purple -t mtinside/blue-green:purple
	docker build . --build-arg COLOUR=red -t mtinside/blue-green:red
	docker build . --build-arg COLOUR=pink -t mtinside/blue-green:pink

test:
	docker run -d --rm --name blue -p 8080 mtinside/blue-green:blue
	docker run -d --rm --name green -p 8080 mtinside/blue-green:green
	docker run -d --rm --name orange -p 8080 mtinside/blue-green:orange
	docker run -d --rm --name purple -p 8080 mtinside/blue-green:purple
	docker run -d --rm --name red -p 8080 mtinside/blue-green:red
	docker run -d --rm --name pink -p 8080 mtinside/blue-green:pink

push:
	docker push mtinside/blue-green

clean:
	cargo clean
