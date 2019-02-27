provider "azurerm" {
    version = "~> 1.22"
}

variable "project" {
    type        = "string"
    default     = "pcms-contoso-non-prod"
    description = "PCMS project identifier, e.g. pcms-<customername>-non-prod*"
}

variable "environment_name" {
    type        = "string"
    default     = "dev2"
    description = "PCMS project identifier, e.g.prod, dev2"
}

variable "prefix" {
    type        = "string"
    default     = "myfirstvmss"
    description = "Prefix for the VMSS names."
}

variable "loc" {
    type        = "string"
    default     = "westeurope"
    description = "Azure region shortname."
}

variable "tags" {
    type        = "map"
    default     = {}
    description = "Map of tag name:value pairs."
}

resource "azurerm_resource_group" {

}

/*
module "vmss" {
    source = "../pcms-module-vmss"
}
*/
