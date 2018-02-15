# More info please refer to: https://www.inspec.io/docs/

# Get path to terraform state file from attribute of kitchen-terraform.
terraform_state = attribute "terraform_state", {}

# Define how critical this control is.
control "state_file3" do
  # Define how critical this control is.
  impact 0.6
  # The actual test case.
  describe file("terraform.tfstate.d/kitchen-terraform-default-linux/terraform.tfstate") do

    file = File.read("terraform.tfstate.d/kitchen-terraform-default-linux/terraform.tfstate")
    # Get json object of terraform state file.
    data_hash = JSON.parse(file)
    modules = data_hash["modules"]

    subject do modules[6]["resources"]["azurerm_network_security_rule.predefined_rules"]["primary"]["attributes"]["name"] end

    # Validate the terraform version number field.
    it "is valid" do is_expected.to match "HTTP" end
  end
end

