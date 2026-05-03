data "twingate_security_policy" "development_security_policy" {
  name = "Development"
}

resource "twingate_resource" "document_db" {
  name              = "DOCUMENT_DB_${upper(terraform.workspace)}"
  address           = var.resource_doc_db_endpoint
  remote_network_id = twingate_remote_network.aws_network.id
  alias             = "docdb.${terraform.workspace}.${var.network}.local"
  is_active         = true

  security_policy_id = data.twingate_security_policy.development_security_policy.id

  protocols = {
    allow_icmp = true
    tcp = {
      policy = "RESTRICTED"
      ports  = ["27017"]
    }
    udp = {
      policy = "DENY_ALL"
    }
  }

  access_group {
    group_id           = twingate_group.aws.id
    security_policy_id = data.twingate_security_policy.development_security_policy.id
  }
}


resource "twingate_resource" "redis_db" {
  name              = "VALKEY_DB_${upper(terraform.workspace)}"
  address           = var.resource_redis_db_endpoint
  remote_network_id = twingate_remote_network.aws_network.id
  alias             = "valkey.${terraform.workspace}.${var.network}.local"
  is_active         = true

  security_policy_id = data.twingate_security_policy.development_security_policy.id

  protocols = {
    allow_icmp = true
    tcp = {
      policy = "RESTRICTED"
      ports  = ["6379"]
    }
    udp = {
      policy = "DENY_ALL"
    }
  }

  access_group {
    group_id           = twingate_group.aws.id
    security_policy_id = data.twingate_security_policy.development_security_policy.id
  }
}

