# This Makefile is meant to be used by people that do not usually work
# with Go source code. If you know what GOPATH is then you probably
# don't need to bother with make.

.PHONY: sft android ios sft-cross evm all test clean
.PHONY: sft-linux sft-linux-386 sft-linux-amd64 sft-linux-mips64 sft-linux-mips64le
.PHONY: sft-linux-arm sft-linux-arm-5 sft-linux-arm-6 sft-linux-arm-7 sft-linux-arm64
.PHONY: sft-darwin sft-darwin-386 sft-darwin-amd64
.PHONY: sft-windows sft-windows-386 sft-windows-amd64

GOBIN = ./build/bin
GO ?= latest
GORUN = env GO111MODULE=on go run

sft:
	$(GORUN) build/ci.go install ./cmd/sft
	@echo "Done building."
	@echo "Run \"$(GOBIN)/sft\" to launch sft."

all:
	$(GORUN) build/ci.go install

android:
	$(GORUN) build/ci.go aar --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/sft.aar\" to use the library."
	@echo "Import \"$(GOBIN)/sft-sources.jar\" to add javadocs"
	@echo "For more info see https://stackoverflow.com/questions/20994336/android-studio-how-to-attach-javadoc"
	
ios:
	$(GORUN) build/ci.go xcode --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/Geth.framework\" to use the library."

test: all
	$(GORUN) build/ci.go test

lint: ## Run linters.
	$(GORUN) build/ci.go lint

clean:
	env GO111MODULE=on go clean -cache
	rm -fr build/_workspace/pkg/ $(GOBIN)/*

# The devtools target installs tools required for 'go generate'.
# You need to put $GOBIN (or $GOPATH/bin) in your PATH to use 'go generate'.

devtools:
	env GOBIN= go get -u golang.org/x/tools/cmd/stringer
	env GOBIN= go get -u github.com/kevinburke/go-bindata/go-bindata
	env GOBIN= go get -u github.com/fjl/gencodec
	env GOBIN= go get -u github.com/golang/protobuf/protoc-gen-go
	env GOBIN= go install ./cmd/abigen
	@type "npm" 2> /dev/null || echo 'Please install node.js and npm'
	@type "solc" 2> /dev/null || echo 'Please install solc'
	@type "protoc" 2> /dev/null || echo 'Please install protoc'

# Cross Compilation Targets (xgo)

sft-cross: sft-linux sft-darwin sft-windows sft-android sft-ios
	@echo "Full cross compilation done:"
	@ls -ld $(GOBIN)/sft-*

sft-linux: sft-linux-386 sft-linux-amd64 sft-linux-arm sft-linux-mips64 sft-linux-mips64le
	@echo "Linux cross compilation done:"
	@ls -ld $(GOBIN)/sft-linux-*

sft-linux-386:
	$(GORUN) build/ci.go xgo -- --go=$(GO) --targets=linux/386 -v ./cmd/sft
	@echo "Linux 386 cross compilation done:"
	@ls -ld $(GOBIN)/sft-linux-* | grep 386

sft-linux-amd64:
	$(GORUN) build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/sft
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/sft-linux-* | grep amd64

sft-linux-arm: sft-linux-arm-5 sft-linux-arm-6 sft-linux-arm-7 sft-linux-arm64
	@echo "Linux ARM cross compilation done:"
	@ls -ld $(GOBIN)/sft-linux-* | grep arm

sft-linux-arm-5:
	$(GORUN) build/ci.go xgo -- --go=$(GO) --targets=linux/arm-5 -v ./cmd/sft
	@echo "Linux ARMv5 cross compilation done:"
	@ls -ld $(GOBIN)/sft-linux-* | grep arm-5

sft-linux-arm-6:
	$(GORUN) build/ci.go xgo -- --go=$(GO) --targets=linux/arm-6 -v ./cmd/sft
	@echo "Linux ARMv6 cross compilation done:"
	@ls -ld $(GOBIN)/sft-linux-* | grep arm-6

sft-linux-arm-7:
	$(GORUN) build/ci.go xgo -- --go=$(GO) --targets=linux/arm-7 -v ./cmd/sft
	@echo "Linux ARMv7 cross compilation done:"
	@ls -ld $(GOBIN)/sft-linux-* | grep arm-7

sft-linux-arm64:
	$(GORUN) build/ci.go xgo -- --go=$(GO) --targets=linux/arm64 -v ./cmd/sft
	@echo "Linux ARM64 cross compilation done:"
	@ls -ld $(GOBIN)/sft-linux-* | grep arm64

sft-linux-mips:
	$(GORUN) build/ci.go xgo -- --go=$(GO) --targets=linux/mips --ldflags '-extldflags "-static"' -v ./cmd/sft
	@echo "Linux MIPS cross compilation done:"
	@ls -ld $(GOBIN)/sft-linux-* | grep mips

sft-linux-mipsle:
	$(GORUN) build/ci.go xgo -- --go=$(GO) --targets=linux/mipsle --ldflags '-extldflags "-static"' -v ./cmd/sft
	@echo "Linux MIPSle cross compilation done:"
	@ls -ld $(GOBIN)/sft-linux-* | grep mipsle

sft-linux-mips64:
	$(GORUN) build/ci.go xgo -- --go=$(GO) --targets=linux/mips64 --ldflags '-extldflags "-static"' -v ./cmd/sft
	@echo "Linux MIPS64 cross compilation done:"
	@ls -ld $(GOBIN)/sft-linux-* | grep mips64

sft-linux-mips64le:
	$(GORUN) build/ci.go xgo -- --go=$(GO) --targets=linux/mips64le --ldflags '-extldflags "-static"' -v ./cmd/sft
	@echo "Linux MIPS64le cross compilation done:"
	@ls -ld $(GOBIN)/sft-linux-* | grep mips64le

sft-darwin: sft-darwin-386 sft-darwin-amd64
	@echo "Darwin cross compilation done:"
	@ls -ld $(GOBIN)/sft-darwin-*

sft-darwin-386:
	$(GORUN) build/ci.go xgo -- --go=$(GO) --targets=darwin/386 -v ./cmd/sft
	@echo "Darwin 386 cross compilation done:"
	@ls -ld $(GOBIN)/sft-darwin-* | grep 386

sft-darwin-amd64:
	$(GORUN) build/ci.go xgo -- --go=$(GO) --targets=darwin/amd64 -v ./cmd/sft
	@echo "Darwin amd64 cross compilation done:"
	@ls -ld $(GOBIN)/sft-darwin-* | grep amd64

sft-windows: sft-windows-386 sft-windows-amd64
	@echo "Windows cross compilation done:"
	@ls -ld $(GOBIN)/sft-windows-*

sft-windows-386:
	$(GORUN) build/ci.go xgo -- --go=$(GO) --targets=windows/386 -v ./cmd/sft
	@echo "Windows 386 cross compilation done:"
	@ls -ld $(GOBIN)/sft-windows-* | grep 386

sft-windows-amd64:
	$(GORUN) build/ci.go xgo -- --go=$(GO) --targets=windows/amd64 -v ./cmd/sft
	@echo "Windows amd64 cross compilation done:"
	@ls -ld $(GOBIN)/sft-windows-* | grep amd64
