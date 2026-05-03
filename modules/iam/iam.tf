# Define the IAM inline policy and attach it to each IAM group
resource "aws_iam_group_policy" "enforce_mfa_policy" {
  for_each = data.aws_iam_group.existing_groups
  name     = "${each.value.group_name}-mfa-enforce"
  group    = each.value.group_name
  policy   = file("${path.module}/resources/mfa_policy.json")
}

# Enforces a strict password policy for IAM users
resource "aws_iam_account_password_policy" "strict_password_policy" {
  minimum_password_length        = 8
  require_uppercase_characters   = true
  require_lowercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  allow_users_to_change_password = true
  max_password_age               = 30
  password_reuse_prevention      = 3
  hard_expiry                    = true
}