#!/usr/bin/env bash
echo "==> Running E2E Tests..."
set -e
cd ./test/e2e
go mod tidy
go mod vendor
if [ -z "$TEST_TIMEOUT" ]; then
    export TEST_TIMEOUT=720m
fi
echo "==> go test"
terraform version
go test -v -p=1 -timeout=$TEST_TIMEOUT ./...