terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0.0"

    }
  }
}

provider "azurerm" {
  tenant_id = "589230e3-7436-4377-9685-393214ba66ee"
  features {}
}