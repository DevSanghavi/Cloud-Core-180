provider "aws" {
  profile = var.profile
  region  = var.region

  default_tags {
    tags = {
      ManagedBy = "Terraform"
      Day       = "Day87"
      Topic     = "TerraformEc2Resource"
      Owner     = "Dev"
    }
  }
}
