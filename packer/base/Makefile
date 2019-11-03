lint:
	packer validate packer.json

test:
	go test -v ./base_test.go -timeout 1h

debug:
	packer build -debug -only=vagrant packer.json

local:
	packer build -only=vagrant packer.json

build:
	packer build -only=amazon-ebs packer.json

clean:
	rm -rf output-vagrant || true
	rm ubuntu-bionic-18.04-cloudimg-console.log || true
	rm -rf packer_cache || true
