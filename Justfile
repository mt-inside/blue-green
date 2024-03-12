set dotenv-load

default:
	@just --list --unsorted --color=always

DH_USER := "mtinside"
GH_USER := "mt-inside"
DH_REPO := "docker.io/" + DH_USER + "/blue-green"
GH_REPO := "ghcr.io/" + GH_USER + "/blue-green"
TAG := `git describe --tags --always --abbrev`
TAGD := `git describe --tags --always --abbrev --dirty --broken`
CGR_ARCHS := "aarch64" # amd64,x86,armv7 - will fail cause no wolfi packages for these archs
MELANGE := "melange"
APKO    := "apko"

run:
	COLOUR=blue cargo run --release

clean:
	cargo clean

build-ci:
	RUSTFLAGS="-C target-feature=+crt-static -C link-arg=-s -Zlocation-detail=none" cargo build -Z build-std=std,panic_abort -Z build-std-features=panic_immediate_abort --target aarch64-unknown-linux-gnu --release

build-color-images:
	docker build . --build-arg COLOUR=blue -t mtinside/blue-green:blue --load
	docker build . --build-arg COLOUR=green -t mtinside/blue-green:green --load
	docker build . --build-arg COLOUR=orange -t mtinside/blue-green:orange --load
	docker build . --build-arg COLOUR=purple -t mtinside/blue-green:purple --load
	docker build . --build-arg COLOUR=red -t mtinside/blue-green:red --load
	docker build . --build-arg COLOUR=pink -t mtinside/blue-green:pink --load

run-color-images:
	docker run -d --rm --name blue -p 8080:8080 mtinside/blue-green:blue
	docker run -d --rm --name green -p 8081:8080 mtinside/blue-green:green
	docker run -d --rm --name orange -p 8082:8080 mtinside/blue-green:orange
	docker run -d --rm --name purple -p 8083:8080 mtinside/blue-green:purple
	docker run -d --rm --name red -p 8084:8080 mtinside/blue-green:red
	docker run -d --rm --name pink -p 8085:8080 mtinside/blue-green:pink

push-all-images: build-color-images
	docker push mtinside/blue-green -a

build-and-push-v1-0-0:
	docker build . --no-cache --build-arg COLOUR=blue -t mtinside/blue-green:1.0.0 --push
build-and-push-v1-0-1:
	docker build . --no-cache --build-arg COLOUR=green -t mtinside/blue-green:1.0.1 --push
build-and-push-v1-1-0:
	docker build . --no-cache --build-arg COLOUR=yellow -t mtinside/blue-green:1.1.0 --push
build-and-push-v2-0-0:
	docker build . --no-cache --build-arg COLOUR=red -t mtinside/blue-green:2.0.0 --push

package:
	rm -rf ./packages/
	{{MELANGE}} keygen
	{{MELANGE}} build --arch {{CGR_ARCHS}} --signing-key melange.rsa melange.yaml

image-local:
	{{APKO}} build --keyring-append melange.rsa.pub --arch {{CGR_ARCHS}} apko.yaml {{GH_REPO}}:{{TAG}} blue-green.tar
	docker load < blue-green.tar
image-publish:
	{{APKO}} login docker.io -u {{DH_USER}} --password "${DH_TOKEN}"
	{{APKO}} login ghcr.io   -u {{GH_USER}} --password "${GH_TOKEN}"
	{{APKO}} publish --keyring-append melange.rsa.pub --arch {{CGR_ARCHS}} apko.yaml {{GH_REPO}}:{{TAG}} {{DH_REPO}}:{{TAG}}
