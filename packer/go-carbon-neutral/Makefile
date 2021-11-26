lint:
	ansible-lint
	packer validate packer.json

test:
	go test -v ./go_carbon_neutral_test.go -timeout 1h

local:
	packer build -only=vagrant packer.json

debug:
	packer build -debug -only=vagrant packer.json

build:
	packer build -only=amazon-ebs packer.json

clean:
	rm -rf output-vagrant || true
	rm *.log || true
	rm -rf packer_cache || true
