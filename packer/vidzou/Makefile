lint:
	ansible-lint
	packer validate packer.json

test:
	go test -v ./vidzou_test.go -timeout 1h

local:
	packer build -only=vagrant packer.json

debug:
	packer build -debug -only=vagrant packer.json

build:
	packer build -only=amazon-ebs packer.json

clean:
	rm -rf output-vagrant || true
	rm ubuntu-bionic-18.04-cloudimg-console.log || true
	rm -rf packer_cache || true
