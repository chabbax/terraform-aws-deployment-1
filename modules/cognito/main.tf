resource "aws_cognito_user_pool" "main" {
  name                     = "${var.app_name}-${terraform.workspace}-user-pool"
  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]
  mfa_configuration        = "OPTIONAL"
  deletion_protection      = "ACTIVE"


  software_token_mfa_configuration {
    enabled = true
  }

  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  schema {
    name                     = "given_name"
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    required                 = true
    string_attribute_constraints {
      min_length = 1
      max_length = 50
    }
  }
  schema {
    name                     = "family_name"
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    required                 = true
    string_attribute_constraints {
      min_length = 1
      max_length = 50
    }
  }

  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}

resource "aws_cognito_user_pool_client" "main" {
  name         = "${var.app_name}-${terraform.workspace}-client"
  user_pool_id = aws_cognito_user_pool.main.id

  # Units are in hours
  access_token_validity = 24
  id_token_validity     = 24

  # Units are in days
  refresh_token_validity = 30

  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["email", "openid", "profile"]

  callback_urls                = ["http://localhost:3000/cognito/callback", "https://dev.authors.ai/cognito/callback", "https://staging.authors.ai/cognito/callback", "https://beta.authors.ai/cognito/callback"]
  enable_token_revocation      = true
  explicit_auth_flows          = ["USER_PASSWORD_AUTH"]
  supported_identity_providers = ["COGNITO"]

}

resource "aws_cognito_user_pool_domain" "main" {
  domain       = "auth-${var.app_name}-${terraform.workspace}"
  user_pool_id = aws_cognito_user_pool.main.id
}

resource "aws_cognito_user_group" "data_scientist" {
  name         = "${var.app_name}-data-sci-user-group-${terraform.workspace}"
  user_pool_id = aws_cognito_user_pool.main.id
  description  = "Group for data scientists"
}


resource "aws_cognito_identity_pool" "main" {
  identity_pool_name               = "${var.app_name}-${terraform.workspace}-identity-pool"
  allow_unauthenticated_identities = false
  allow_classic_flow               = false
  developer_provider_name          = "${var.app_name}-${terraform.workspace}-developer-provider"

  # Add the user pool as an identity provider
  cognito_identity_providers {
    client_id               = aws_cognito_user_pool_client.main.id
    provider_name           = aws_cognito_user_pool.main.endpoint
    server_side_token_check = false
  }

  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}

resource "aws_iam_role" "authenticated_role" {
  name = "${var.app_name}-${terraform.workspace}-authenticated-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "cognito-identity.amazonaws.com"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "cognito-identity.amazonaws.com:aud" : aws_cognito_identity_pool.main.id
          },
          "ForAnyValue:StringLike" : {
            "cognito-identity.amazonaws.com:amr" : "authenticated"
          }
        }
      }
    ]
  })
}


resource "aws_iam_role" "documentDB_access_role" {
  name        = "${var.app_name}-${terraform.workspace}-documentdb-connect-describe"
  description = "Allow connect and describe access to Amazon DocumentDB"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "cognito-identity.amazonaws.com"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "cognito-identity.amazonaws.com:aud" : aws_cognito_identity_pool.main.id
          },
          "ForAnyValue:StringLike" : {
            "cognito-identity.amazonaws.com:amr" : "authenticated"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "documentDB_access_policy" {
  name        = "${var.app_name}-${terraform.workspace}-documentdb-connect-describe"
  description = "Allow connect and describe access to Amazon DocumentDB"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "rds:DescribeDBInstances",
          "rds:DescribeDBClusters"
        ],
        "Resource" : [
          "arn:aws:rds:${var.aws_region}:${var.account_id}:db:${var.documentdb_instance_id}",
          "arn:aws:rds:${var.aws_region}:${var.account_id}:cluster:${var.documentdb_cluster_id}"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_documentDB_access_policy" {
  role       = aws_iam_role.documentDB_access_role.name
  policy_arn = aws_iam_policy.documentDB_access_policy.arn
}

resource "aws_cognito_identity_pool_roles_attachment" "main" {
  identity_pool_id = aws_cognito_identity_pool.main.id

  roles = {
    "authenticated" = aws_iam_role.authenticated_role.arn
  }

  role_mapping {
    type                      = "Rules"
    ambiguous_role_resolution = "AuthenticatedRole"
    identity_provider         = "${aws_cognito_user_pool.main.endpoint}:${aws_cognito_user_pool_client.main.id}"

    mapping_rule {
      claim      = "cognito:groups"
      match_type = "Contains"
      value      = aws_cognito_user_group.data_scientist.name
      role_arn   = aws_iam_role.documentDB_access_role.arn
    }
  }
}


