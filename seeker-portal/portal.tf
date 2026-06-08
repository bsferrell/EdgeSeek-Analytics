terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "portal_bucket" {
  bucket        = "edgeseek-coach-portal-frontend" 
  force_destroy = true

  tags = {
    Name        = "edgeseek-frontend-portal"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_website_configuration" "portal_config" {
  bucket = aws_s3_bucket.portal_bucket.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "allow_public_frontend" {
  bucket                  = aws_s3_bucket.portal_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# 4. Create a Bucket Policy that allows anyone on the internet to READ the website files
resource "aws_s3_bucket_policy" "allow_public_read" {
  bucket     = aws_s3_bucket.portal_bucket.id
  depends_on = [aws_s3_bucket_public_access_block.allow_public_frontend]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.portal_bucket.arn}/*"
      }
    ]
  })
}

output "portal_website_url" {
  value       = aws_s3_bucket_website_configuration.portal_config.website_endpoint
  description = "The public URL for the EdgeSeek Coach Portal"
}

resource "aws_s3_object" "upload_index" {
  bucket       = aws_s3_bucket.portal_bucket.id
  key          = "index.html"
  source       = "../frontend/index.html"
  content_type = "text/html"
  
  # Tracks file changes so it updates if you edit the HTML file locally
  etag = filemd5("../frontend/index.html")
}