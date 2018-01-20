.PHONY: all echo build push deploy

TAG:=dev-$(shell date +%s)

all: build

echo:
	@docker run --rm -it -p 8000:8000 paddycarey/go-echo

build:
	docker build --no-cache --pull -t quay.io/wisvch/oidc-proxy:${TAG} -t quay.io/wisvch/oidc-proxy:latest .

push: build
	@docker push quay.io/wisvch/oidc-proxy:${TAG}
	@docker push quay.io/wisvch/oidc-proxy:latest

deploy: push
	@kubectl set image deployment -n kube-system kubernetes-dashboard oidc-proxy=quay.io/wisvch/oidc-proxy:${TAG}
	@kubectl set image deployment -n beheer userman2 oidc-proxy=quay.io/wisvch/oidc-proxy:${TAG}
