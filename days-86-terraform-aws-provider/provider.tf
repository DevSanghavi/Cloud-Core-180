provider "aws" {
  profile = var.profile
  region  = var.region

  default_tags {
    tags = {
      ManagedBy = "Terraform"
      Day       = "Day86"
      Topic     = "TerraformAwsProvider"
      Owner     = "Dev"
    }
  }
}
