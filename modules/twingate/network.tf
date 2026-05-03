resource "twingate_remote_network" "aws_network" {
  location = "AWS"
  name     = "${title(terraform.workspace)} Network"
}

resource "twingate_group" "aws" {
  name = "AWS ${title(terraform.workspace)} Access"
}

resource "twingate_connector" "aws_connector" {
  remote_network_id = twingate_remote_network.aws_network.id
}

resource "twingate_connector_tokens" "aws_connector_tokens" {
  connector_id = twingate_connector.aws_connector.id
}
