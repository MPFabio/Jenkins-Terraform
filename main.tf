variable "resource_group_location" {
  default     = "westeurope"
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  default     = "rg-fabio-"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "subscription_id" {
   description = "Azure subscription"
   default = "393e3de3-0900-4b72-8f1b-fb3b1d6b97f1"
}

variable "client_id" {
   description = "Azure Client ID"
   default = "5375c5be-6a88-4949-880d-e76e1481a45a"
}

variable "client_secret" {
   description = "Azure Client Secret"
   default = "f6eb23e0-1e66-4d98-956b-fad6b5da2c6d"
}

variable "tenant_id" {
   description = "Azure Tenant ID"
   default = "7349d3b2-951f-41be-877e-d8ccd9f3e73c"
} 

terraform {
   required_version = ">= 0.12"
   required_providers {
      azurerm = ">3.0"
   }
}

provider "azurerm" {
   subscription_id = var.subscription_id
   #client_id = var.client_id
   #client_secret = var.client_secret
   tenant_id = var.tenant_id
   skip_provider_registration = true
   features {}
}

resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = random_pet.rg_name.id
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}
