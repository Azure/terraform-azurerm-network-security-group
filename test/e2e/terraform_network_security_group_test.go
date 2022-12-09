package e2e

import (
	"fmt"
	"log"
	"os"
	"strings"
	"testing"

	test_helper "github.com/Azure/terraform-module-test-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestCassandra(t *testing.T) {
	test_helper.RunE2ETest(t, "../../", "examples/Cassandra", terraform.Options{
		Upgrade: true,
	}, func(t *testing.T, output test_helper.TerraformOutput) {
	})
}

func TestExamples(t *testing.T) {
	directories, err := os.ReadDir("../../examples")
	if err != nil {
		log.Fatal(err)
	}
	managedIdentityId := os.Getenv("MSI_ID")
	if managedIdentityId != "" {
		_ = os.Setenv("TF_VAR_managed_identity_principal_id", managedIdentityId)
	}

	for _, d := range directories {
		if strings.HasPrefix(d.Name(), "_") || strings.Contains(d.Name(), "test") || !d.IsDir() {
			continue
		}
		t.Run(d.Name(), func(t *testing.T) {
			test_helper.RunE2ETest(t, "../../", fmt.Sprintf("examples/%s", d.Name()), terraform.Options{
				Upgrade: true,
				//Parallelism: 1,
			}, func(t *testing.T, output test_helper.TerraformOutput) {
			})
		})
	}
}
