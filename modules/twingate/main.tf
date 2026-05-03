terraform {
  required_providers {
    twingate = {
      source  = "Twingate/twingate"
      version = "3.0.11"
    }
  }
}

provider "twingate" {
  api_token = var.twingate_api_token
  network   = var.network
}
