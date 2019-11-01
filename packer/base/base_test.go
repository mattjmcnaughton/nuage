package main

import (
	"testing"

	terratest_aws "github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/packer"
)

func TestPackerBaseAMI(t *testing.T) {
	// For now, we hard code region. We may not wish to continue hard-coding
	// us-east-1 long term.
	awsRegion := "us-east-1"

	packerOptions := &packer.Options{
		Template: "./packer.json",

		Only: "amazon-ebs",
	}

	amiID := packer.BuildArtifact(t, packerOptions)
	defer terratest_aws.DeleteAmiAndAllSnapshots(t, awsRegion, amiID)

	// `BuildArtifact` will fail if we do not successfully build the AMI.
	// For now, we don't feel the need to do richer assertions.
}

// We do not test generating the Vagrant images, as those are for local
// development.
