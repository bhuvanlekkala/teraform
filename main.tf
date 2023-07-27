# main.tf

# Create the Google Cloud Storage bucket
resource "google_storage_bucket" "website" {
  name     = "example-website-by-bhuvan"
  location = "eu"
}

# Define the access control rule for the bucket
resource "google_storage_bucket_access_control" "public_rule" {
  bucket = google_storage_bucket.website.name
  role   = "READER"
  entity = "allUsers"
}

# Upload html file to the bucket
resource "google_storage_bucket_object" "static_site_src" {
  name   = "index.html"
  source = "C:/Users/Divesh/learn-terraform-gcp/Website/index.html"
  bucket = google_storage_bucket.website.name
}

# Reserve an external IP address for Load Balancer
resource "google_compute_global_address" "website" {
  name = "website-lb-ip"
}

# main.tf

resource "google_dns_managed_zone" "zone" {
  name        = "bhuvan-cloud-zone"
  dns_name    = "bhuvan.cloud."
  description = "Test DNS zone for bhuvan.cloud."
}

resource "google_dns_record_set" "soa_record" {
  name    = "bhuvan.cloud."
  type    = "SOA"
  ttl     = 21600 # 6 hours
  managed_zone = google_dns_managed_zone.zone.name

  rrdatas = [
    "ns-cloud-e1.googledomains.com. cloud-dns-hostmaster.google.com. 1 21600 3600 259200 300",
  ]
}

resource "google_dns_record_set" "ns_record" {
  name    = "bhuvan.cloud."
  type    = "NS"
  ttl     = 21600 # 6 hours
  managed_zone = google_dns_managed_zone.zone.name

  rrdatas = [
    "ns-cloud-e1.googledomains.com.",
  ]
}


# Create CDN backend for the bucket
resource "google_cdn_backend_bucket" "bucket_cdn_backend" {
  bucket_name = google_storage_bucket.website.name
  description = "CDN backend for the website bucket"
}

 #Create DNS record set for the website
resource "google_dns_record_set" "website" {
  name        = "example.com"  # Replace with your domain name
  managed_zone = google_dns_managed_zone.bhuvan-cloud-zone.name
  rrdatas     = [google_storage_bucket.website.website_endpoint]  # Assuming you have a website_endpoint output in the google_storage_bucket.website resource
  ttl         = 300
  type        = "A"
}

# Create HTTPS certificate
resource "google_compute_managed_ssl_certificate" "website" {
  provider = google-beta
  name     = "website-cert"
  managed {
    domains = [google_dns_record_set.website.name]
  }
}
