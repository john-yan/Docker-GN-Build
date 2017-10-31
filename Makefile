
ARCH := $(shell uname -m | tr '[:upper:]' '[:lower:]')
BUILDTOOLS := $(PWD)/deps/buildtools
IMAGE := gn-build-env

all: build-and-upload-gn

build-image:
	docker build -t $(IMAGE) .

download-deps: .deps-downloaded

.deps-downloaded:
	git clone git@github.com:john-yan/ibm-buildtools-for-v8.git deps/buildtools
	touch .deps-downloaded

update-deps: download-deps
	cd "$(BUILDTOOLS)" && git remote update && git reset --hard origin/master

build-and-update-gn:
	docker run --rm -v "$(BUILDTOOLS)/buildtools-$(ARCH):/buildtools" $(IMAGE) bash -x /srcdir/script.sh

upload-gn:
	$(eval VERSION := $(shell "$(BUILDTOOLS)/buildtools-$(ARCH)/gn" --version))
	cd "$(BUILDTOOLS)" && \
	git commit ./buildtools-$(ARCH)/gn -m "GN: Update $(ARCH) gn to $(VERSION)" && \
	git push

build-and-upload-gn: build-and-update-gn
	$(eval VERSION := $(shell "$(BUILDTOOLS)/buildtools-$(ARCH)/gn" --version))
	cd "$(BUILDTOOLS)" && \
	git commit ./buildtools-$(ARCH)/gn -m "GN: Update $(ARCH) gn to $(VERSION)" && \
	git push

run:
	docker run --rm -it -v "$(PWD)/buildtools-$(ARCH):/buildtools" $(IMAGE) bash || true

.PHONY: build-images build-and-update-gn upload-gn build-and-upload-gn run download-deps update-deps

