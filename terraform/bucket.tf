resource "aws_s3_bucket" "ts_bucket" {
  bucket        = "spotlink-static-${random_id.suffix.hex}"
  force_destroy = true
}
