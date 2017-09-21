SHELL=/bin/bash
APP_ROOT := $(shell pwd)
VENDOR_ROOT := $(APP_ROOT)/vendor
SRC_FILES := $(shell git ls-files $(APP_ROOT)/src)
GINKGO := $(APP_ROOT)/bin/ginkgo
export ATLANTIS_CONFIG_PREFIX := $(PWD)/
export GOPATH := $(APP_ROOT):$(VENDOR_ROOT)
export PATH := $(APP_ROOT)/node_modules/.bin:$(PATH)
export APP_ROOT

all: build

clean:
	@rm -rf $(APP_ROOT)/bin
	@rm -rf $(APP_ROOT)/pkg
	@rm -rf $(APP_ROOT)/package

init:
	@mkdir -p bin
	@mkdir -p package

bin/ginkgo:
	@echo "==> Building ginkgo..."
	@go build -o bin/ginkgo ./vendor/src/github.com/onsi/ginkgo/ginkgo

build: init $(SRC_FILES) bin/ginkgo
	@echo "==> Build Go App"
	@go build -o bin/ppt ./src/entrypoint/

test: package
	@echo "==> Running ALL test suites..."
	cd $(APP_ROOT)/src && $(GINKGO) -r -v

package: build
	@echo "===> Package"
	@cp -r scripts package/
	@cp bin/ppt package/

run: package
	@echo "==> run..."
	bin/ppt
