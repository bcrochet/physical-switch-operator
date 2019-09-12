TEST_NAMESPACE = operator-test
RUN_NAMESPACE = metal3
IMAGE_REGISTRY = quay.io/bcrochet
DEBUG = --debug

# Set some variables the operator expects to have in order to work
export OPERATOR_NAME=physical-switch-operator

.PHONY: help
help:
	@echo "Targets:"
	@echo "  clean            -- Delete all resources"
	@echo "  build            -- Build the operator with podman"
	@echo "  deploy           -- Deploy the operator"
	@echo "  push             -- Push the operator to quay.io"
	@echo "  help             -- this help output"
	@echo
	@echo "Variables:"
	@echo "  TEST_NAMESPACE   -- project name to use ($(TEST_NAMESPACE))"
	@echo "  DEBUG            -- debug flag, if any ($(DEBUG))"

.PHONY: clean
clean:
	-kubectl delete -f deploy/operator.yaml
	-kubectl delete -f deploy/crds/metal3_v1alpha1_switch_crd.yaml
	-kubectl delete -f deploy/role_binding.yaml
	-kubectl delete -f deploy/role.yaml
	-kubectl delete -f deploy/service_account.yaml

.PHONY: run
run:
	operator-sdk up local \
		--go-ldflags=$(LDFLAGS) \
		--namespace=$(RUN_NAMESPACE) \
		--operator-flags="-dev"

.PHONY: build
build:
	operator-sdk build --image-builder podman "quay.io/bcrochet/physical-switch-operator:v0.0.1"

.PHONY: push
push:
	podman push "${IMAGE_REGISTRY}/physical-switch-operator:v0.0.1"

.PHONY: deploy
deploy:
	kubectl apply -f deploy/service_account.yaml
	kubectl apply -f deploy/role.yaml
	kubectl apply -f deploy/role_binding.yaml
	kubectl apply -f deploy/crds/metal3_v1alpha1_switch_crd.yaml
	kubectl apply -f deploy/operator.yaml

