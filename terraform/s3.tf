####################################################
# Public Access Bucket
####################################################

resource "aws_s3_bucket" "public_access_bucket" {
  bucket        = "${local.app_name}-public-access-bucket"
  force_destroy = true
  acl           = "public-read"

  cors_rule {
    allowed_origins = ["https://api.bosailv.com"]
    allowed_methods = ["GET"]
    allowed_headers = ["*"]
    max_age_seconds = 3600
  }
}
