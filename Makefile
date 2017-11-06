
ARCH := $(shell uname -m | tr '[:upper:]' '[:lower:]')
BUILDTOOLS := $(PWD)/deps/buildtools
IMAGE := gn-build-env

all: build-and-upload-gn

ifeq ($(V), 1)
  BASH := bash -x
else
  BASH := bash
endif

build-image:
	$(BASH) $(PWD)/update-image.sh

build-and-upload-gn: build-image
	docker run --rm -v "$(HOME):/root/host_home" $(IMAGE) $(BASH) /src/build-and-upload-gn.sh

run:
	docker run --rm -it -v "$(HOME):/root/host_home" $(IMAGE) bash || true

.PHONY: build-images build-and-upload-gn run

