# Create IAM role for accessing the media bucket
resource "aws_iam_role" "media_bucket_role" {
  name = "${var.app_name}-media-bucket-role-${terraform.workspace}"

  assume_role_policy = templatefile("${path.module}/resources/assume_role_policy.json", {
    app_name            = var.app_name,
    terraform_workspace = terraform.workspace
  })
}

# Attach a policy to the role allowing S3 access
resource "aws_iam_role_policy" "media_bucket_role_policy" {
  role = aws_iam_role.media_bucket_role.id

  policy = templatefile("${path.module}/resources/media_bucket_role_policy.json", {
    aws_s3_bucket_media_arn = aws_s3_bucket.media_bucket.arn
  })
}

# Create IAM role for accessing the asset files bucket
resource "aws_iam_role" "asset_files_bucket_role" {
  name = "${var.app_name}-asset-files-role-${terraform.workspace}"

  assume_role_policy = templatefile("${path.module}/resources/assume_role_policy.json", {
    app_name            = var.app_name,
    terraform_workspace = terraform.workspace
  })
}

# Attach a policy to the role allowing S3 access
resource "aws_iam_role_policy" "asset_files_role_policy" {
  role = aws_iam_role.asset_files_bucket_role.id

  policy = templatefile("${path.module}/resources/asset_files_bucket_role_policy.json", {
    aws_s3_bucket_asset_files_arn = aws_s3_bucket.marlowe_asset_files_bucket.arn
  })
}