terraform {
  required_version = ">= 0.12"

  required_providers {
    ec = {
      source  = "elastic/ec"
      version = "0.1.0-beta"
    }
  }
}

provider "ec" {
  apikey = "$API_KEY"
}

