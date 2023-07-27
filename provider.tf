# provider.tf

locals {
  gcp_creds = jsondecode(file("C:/Users/Divesh/learn-terraform-gcp/Website/youtube.json"))
}

# GCP Provider
provider "google" {
  credentials = jsonencode(local.gcp_creds)
  project     = "youtube-393909"
  region      = "europe-west2"
}
