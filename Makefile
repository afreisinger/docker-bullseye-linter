VERSION=latest
TZ = America/Argentina/Buenos_Aires
CREATED=$(shell TZ=$(TZ) date +%Y-%m-%dT%H:%M:%S%z)
REVISION=$(shell git rev-parse HEAD)

build:
	@echo "Building Docker image with CREATED=$(CREATED), REVISION=$(REVISION), VERSION=$(VERSION)"
	VERSION=$(VERSION) CREATED=$(CREATED) REVISION=$(REVISION) docker compose build

up:
	export CREATED=${CREATED} REVISION=${REVISION} && docker compose up

down:
	docker compose down
