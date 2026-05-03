# Media bucket
resource "aws_s3_bucket" "media_bucket" {
  bucket        = "${var.app_name}-media-bucket-${terraform.workspace}"
  force_destroy = true

  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}

# Allow enabling ACL by bucket ownership control for media bucket
resource "aws_s3_bucket_ownership_controls" "media_bucket_ownership_controls" {
  bucket = aws_s3_bucket.media_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Block all public access to media bucket
resource "aws_s3_bucket_public_access_block" "private_access_block" {
  bucket = aws_s3_bucket.media_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 CORS enabled for allowed origins in media bucket
resource "aws_s3_bucket_cors_configuration" "media_bucket_s3_cors" {
  bucket = aws_s3_bucket.media_bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD", "PUT"]
    allowed_origins = toset(var.s3_cors_allowed_origins)
    expose_headers  = ["access-control-allow-origin", "ETag"]
    max_age_seconds = 3000
  }
}

# Define IAM policy document for media bucket
resource "aws_s3_bucket_policy" "media_bucket_policy_attachment" {
  bucket = aws_s3_bucket.media_bucket.id
  policy = templatefile("${path.module}/resources/media_bucket_policy.json", {
    aws_s3_bucket_media_arn = aws_s3_bucket.media_bucket.arn,
    media_bucket_role_arn   = aws_iam_role.media_bucket_role.arn
  })
}

# Apply bucket server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "media_bucket_encryption" {
  bucket = aws_s3_bucket.media_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_lambda_permission" "allow_s3_invoke" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = var.document_preprocessing_lambda_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.media_bucket.arn
}


resource "aws_s3_bucket" "marlowe_asset_files_bucket" {
  bucket        = "marlowe-asset-files-${terraform.workspace}"
  force_destroy = true

  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}

resource "aws_s3_bucket_public_access_block" "marlowe_asset_files_private_access_block" {
  bucket = aws_s3_bucket.marlowe_asset_files_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 CORS enabled for allowed origins in asset files bucket
resource "aws_s3_bucket_cors_configuration" "marlowe_asset_files_s3_cors" {
  bucket = aws_s3_bucket.marlowe_asset_files_bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD", "PUT"]
    allowed_origins = toset(var.s3_cors_allowed_origins)
    expose_headers  = ["access-control-allow-origin", "ETag"]
    max_age_seconds = 3000
  }
}

# Define IAM policy document for asset files bucket
resource "aws_s3_bucket_policy" "marlowe_asset_files_policy_attachment" {
  bucket = aws_s3_bucket.marlowe_asset_files_bucket.id
  policy = templatefile("${path.module}/resources/marlowe_asset_files_policy.json", {
    aws_s3_bucket_asset_files_arn = aws_s3_bucket.marlowe_asset_files_bucket.arn,
    asset_files_role_arn          = aws_iam_role.asset_files_bucket_role.arn
  })
}

# Apply bucket server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "asset_files_bucket_encryption" {
  bucket = aws_s3_bucket.marlowe_asset_files_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3 bucket for Swagger documentation
resource "aws_s3_bucket" "swagger_asset_files_bucket" {
  bucket        = "swagger-files-${terraform.workspace}"
  force_destroy = true

  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}

resource "aws_s3_bucket_website_configuration" "swagger_docs" {
  bucket = aws_s3_bucket.swagger_asset_files_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "swagger_asset_files_bucket" {
  bucket                  = aws_s3_bucket.swagger_asset_files_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "swagger_asset_files_bucket" {
  bucket = aws_s3_bucket.swagger_asset_files_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = "${aws_s3_bucket.swagger_asset_files_bucket.arn}/*"
        Condition = {
          IpAddress = {
            "aws:SourceIp" = var.swagger_allowed_ips
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_cors_configuration" "swagger_asset_files_bucket_s3_cors" {
  bucket = aws_s3_bucket.swagger_asset_files_bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD", "PUT"]
    allowed_origins = [
      "http://${aws_s3_bucket.swagger_asset_files_bucket.bucket}.s3-website-${var.aws_region}.amazonaws.com"
    ]
    expose_headers  = ["access-control-allow-origin", "ETag"]
    max_age_seconds = 3000
  }
}
