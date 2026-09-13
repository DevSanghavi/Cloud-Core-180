provider "aws" {
  profile = var.profile
  region  = var.region

  default_tags {
    tags = {
      ManagedBy = "Terraform"
      Day       = "Day88"
      Topic     = "TerraformS3RemoteState"
      Owner     = "Dev"
    }
  }
}
