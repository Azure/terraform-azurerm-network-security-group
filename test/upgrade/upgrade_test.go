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
		directory := d
		if strings.HasPrefix(directory.Name(), "_") || strings.Contains(directory.Name(), "test") || !directory.IsDir() {
			continue
		}
		useForEach := []bool{
			false,
			true,
		}
		for _, f := range useForEach {
			t.Run(fmt.Sprintf("%s-%t", directory.Name(), f), func(t *testing.T) {
				t.Setenv("TF_VAR_use_for_each", fmt.Sprintf("%t", f))
				test_helper.ModuleUpgradeTest(t, "Azure", "terraform-azurerm-network-security-group", fmt.Sprintf("examples/%s", d.Name()), currentRoot, terraform.Options{
					Upgrade: true,
				}, currentMajorVersion)
			})
		}
	}
}
