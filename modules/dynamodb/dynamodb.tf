resource "aws_dynamodb_table" "table" {
  name                        = "PrimaryTable"
  billing_mode                = "PAY_PER_REQUEST"
  deletion_protection_enabled = true

  on_demand_throughput {
    max_read_request_units  = var.max_read_request_units
    max_write_request_units = var.max_write_request_units
  }

  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"


  hash_key  = "PK"
  range_key = "SK"

  attribute {
    name = "PK"
    type = "S"
  }

  attribute {
    name = "SK"
    type = "S"
  }

  attribute {
    name = "createdAt"
    type = "S"
  }

  attribute {
    name = "owner"
    type = "S"
  }

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "versionId"
    type = "S"
  }

  attribute {
    name = "tokenHash"
    type = "S"
  }

  global_secondary_index {
    name            = "owner-index"
    hash_key        = "owner"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "id-index"
    hash_key        = "id"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "versionId-index"
    hash_key        = "versionId"
    projection_type = "ALL"
  }

  local_secondary_index {
    name            = "createdAt-index"
    range_key       = "createdAt"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "owner-createdAt-index"
    hash_key        = "owner"
    range_key       = "createdAt"
    projection_type = "ALL"
  }
  global_secondary_index {
    name            = "tokenHash-index"
    hash_key        = "tokenHash"
    projection_type = "ALL"
  }

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled = true
  }


  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}

