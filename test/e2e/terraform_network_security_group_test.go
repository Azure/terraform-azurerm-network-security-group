package e2e

import (
	"fmt"
	"os"
	"strings"
	"testing"

	test_helper "github.com/Azure/terraform-module-test-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestExamples(t *testing.T) {
	directories, err := os.ReadDir("../../examples")
	if err != nil {
		t.Fatal(err)
	}

	for _, d := range directories {
		if strings.HasPrefix(d.Name(), "_") || strings.Contains(d.Name(), "test") || !d.IsDir() {
			continue
		}
		t.Run(d.Name(), func(t *testing.T) {
			test_helper.RunE2ETest(t, "../../", fmt.Sprintf("examples/%s", d.Name()), terraform.Options{
				Upgrade: true,
			}, func(t *testing.T, output test_helper.TerraformOutput) {
				nsgId, ok := output["network_security_group_id"].(string)
				assert.True(t, ok)
				assert.Regexp(t, "/subscriptions/.+/resourceGroups/.+/providers/Microsoft.Network/networkSecurityGroups/.+", nsgId)
			})
		})
	}
}
