build:
	CARGO_BUILD_TARGET="x86_64-unknown-linux-musl" RUSTFLAGS="-C target-feature=+crt-static -C link-arg=-s" cargo build --release

run:
	COLOUR=blue cargo run

clean:
	cargo clean

build-color-images:
	docker build . --build-arg COLOUR=blue -t mtinside/blue-green:blue
	docker build . --build-arg COLOUR=green -t mtinside/blue-green:green
	docker build . --build-arg COLOUR=orange -t mtinside/blue-green:orange
	docker build . --build-arg COLOUR=purple -t mtinside/blue-green:purple
	docker build . --build-arg COLOUR=red -t mtinside/blue-green:red
	docker build . --build-arg COLOUR=pink -t mtinside/blue-green:pink

run-color-images:
	docker run -d --rm --name blue -p 8080:8080 mtinside/blue-green:blue
	docker run -d --rm --name green -p 8081:8080 mtinside/blue-green:green
	docker run -d --rm --name orange -p 8082:8080 mtinside/blue-green:orange
	docker run -d --rm --name purple -p 8083:8080 mtinside/blue-green:purple
	docker run -d --rm --name red -p 8084:8080 mtinside/blue-green:red
	docker run -d --rm --name pink -p 8085:8080 mtinside/blue-green:pink

push-all-images:
	docker push mtinside/blue-green -a

build-and-push-v1-0-0:
	docker build . --build-arg COLOUR=blue -t mtinside/blue-green:1.0.0
	docker push mtinside/blue-green:1.0.0
build-and-push-v1-0-1:
	docker build . --build-arg COLOUR=green -t mtinside/blue-green:1.0.1
	docker push mtinside/blue-green:1.0.1
build-and-push-v1-1-0:
	docker build . --build-arg COLOUR=yellow -t mtinside/blue-green:1.1.0
	docker push mtinside/blue-green:1.1.0
build-and-push-v2-0-0:
	docker build . --build-arg COLOUR=red -t mtinside/blue-green:2.0.0
	docker push mtinside/blue-green:2.0.0
