package upgrade

import (
	"fmt"
	"os"
	"strings"
	"testing"

	test_helper "github.com/Azure/terraform-module-test-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestUpgrade(t *testing.T) {
	directories, err := os.ReadDir("../../examples")
	if err != nil {
		t.Fatal(err)
	}
	currentRoot, err := test_helper.GetCurrentModuleRootPath()
	if err != nil {
		t.FailNow()
	}
	currentMajorVersion, err := test_helper.GetCurrentMajorVersionFromEnv()
	if err != nil {
		t.FailNow()
	}
	for _, d := range directories {
		if strings.HasPrefix(d.Name(), "_") || strings.Contains(d.Name(), "test") || !d.IsDir() {
			continue
		}
		t.Run(d.Name(), func(t *testing.T) {
			test_helper.ModuleUpgradeTest(t, "Azure", "terraform-azurerm-network-security-group", fmt.Sprintf("examples/%s", d.Name()), currentRoot, terraform.Options{
				Upgrade: true,
			}, currentMajorVersion)
		})
	}
}
