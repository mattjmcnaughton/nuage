package main

import (
	"testing"

	terratest_aws "github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/packer"
	"github.com/stretchr/testify/assert"
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

	// At some point, we may want to extract a generic set of helper
	// functions... we will likely have this check for all AMI's we test.
	requestingAccount := terratest_aws.CanonicalAccountId
	randomAccount := "123456789012"
	accountsWithLaunchPermissions := terratest_aws.GetAccountsWithLaunchPermissionsForAmi(t, awsRegion, amiID)
	assert.Contains(t, accountsWithLaunchPermissions, requestingAccount)
	assert.NotContains(t, accountsWithLaunchPermissions, randomAccount)
}

// Do we also want to test Vagrant? Or is that more for local
// development?
