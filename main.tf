terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.84.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.6.3"
    }
  }
  
}


provider "aws" {
  # Configuration options
  region = "us-east-1"
}


resource "random_id" "ID" {
    byte_length = 8
}


resource "aws_s3_bucket" "example" {
  bucket = "example"
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.webapp.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_policy" "mywebapp" {
  bucket = aws_s3_bucket.mywebapp-bucket.id
  policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Sid       = "PublicReadGetObject",
          Effect    = "Allow",
          Principal = "*",
          Action    = "s3:GetObject",
          Resource  = "${aws_s3_bucket.mywebapp-bucket.arn}/*"
        }
      ]
    }
  )
}


resource "aws_s3_bucket" "webapp" {
    bucket = "webappbucket"
}


resource "aws_s3_object" "index_html" {
    source = "./index.html"
    key = "index.html"
    bucket = aws_s3_bucket.webapp.bucket
    content_type = "text/html"
}


resource "aws_s3_object" "styles_css" {
    source = "./styles.css"
    key = "styles.css"
    bucket = aws_s3_bucket.webapp.bucket
    content_type = "text/css"
}


output "name" {
  value = aws_s3_bucket.example.website_endpoint
}