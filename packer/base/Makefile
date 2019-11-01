lint:
	packer validate packer.json

test: lint
	packer build -only=vagrant packer.json

debug:
	packer build -debug -only=vagrant packer.json

build:
	packer build -only=amazon-ebs packer.json

gotest:
	go test -v ./base_test.go -timeout 1h

clean:
	rm -rf output-vagrant || true
	rm ubuntu-bionic-18.04-cloudimg-console.log || true
	rm -rf packer_cache || true
