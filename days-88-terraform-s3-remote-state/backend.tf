terraform {
  backend "s3" {
    bucket       = "day88-terraform-state-151024280292-1789302161"
    key          = "day-88/terraform.tfstate"
    region       = "us-east-1"
    profile      = "cloudmentor-admin"
    encrypt      = true
    use_lockfile = true
  }
}
