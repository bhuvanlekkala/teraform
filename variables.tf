# variables.tf

variable "gcp_svc_key" {
  type        = string
  description = "Path to the Google Cloud service account key file."
  default     = "../youtube.json"
}

variable "gcp_project" {
  type        = string
  description = "Google Cloud Platform project name."
  default     = "youtube-393909"
}

variable "gcp_region" {
  type        = string
  description = "Google Cloud region for resources."
  default     = "europe-west2"
}
