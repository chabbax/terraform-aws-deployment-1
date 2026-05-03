# Retrieve the existing IAM groups dynamically
data "aws_iam_group" "existing_groups" {
  for_each   = toset(var.group_names)
  group_name = each.value
}