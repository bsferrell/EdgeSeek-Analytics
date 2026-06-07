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

resource "aws_s3_bucket" "data_ingest_bucket" {
  bucket = "guilford-college-basketball"
}

resource "aws_s3_bucket_public_access_block" "data_ingest_bucket_pab" {
  bucket = aws_s3_bucket.data_ingest_bucket.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "data_ingest_bucket_encryption" {
  bucket = aws_s3_bucket.data_ingest_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "data_ingest_bucket_versioning" {
  bucket = aws_s3_bucket.data_ingest_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "data_ingest_logs_bucket" {
  bucket = "guilford-college-basketball-logs"
}

resource "aws_s3_bucket_public_access_block" "data_ingest_logs_bucket_pab" {
  bucket = aws_s3_bucket.data_ingest_logs_bucket.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "data_ingest_logs_bucket_encryption" {
  bucket = aws_s3_bucket.data_ingest_logs_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_logging" "data_ingest_bucket_logging" {
  bucket = aws_s3_bucket.data_ingest_bucket.id

  target_bucket = aws_s3_bucket.data_ingest_logs_bucket.id
  target_prefix = "access-logs/"
}
