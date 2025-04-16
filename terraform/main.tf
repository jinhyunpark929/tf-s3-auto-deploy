provider "aws" {
  region = "ap-northeast-2"
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "static_site" {
  bucket        = "spotlink-static-${random_id.suffix.hex}"
  force_destroy = true
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.static_site.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.static_site.bucket

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.static_site.bucket

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "PublicReadGetObject"
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.static_site.arn}/*"
    }]
  })
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.static_site.bucket
  key          = "index.html"
  source       = "../assets/index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.static_site.bucket
  key          = "error.html"
  source       = "../assets/error.html"
  content_type = "text/html"
}

resource "aws_s3_object" "wallpaper" {
  bucket       = aws_s3_bucket.static_site.bucket
  key          = "images/home_wallpaper.jpg"
  source       = "../assets/images/home_wallpaper.jpg"
  content_type = "image/jpeg"
}
