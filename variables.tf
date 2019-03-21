variable "project" {
    type        = "string"
    description = "PCMS project identifier, e.g. pcms-<customername>-non-prod*"
}

variable "environment_name" {
    type        = "string"
    description = "PCMS project identifier, e.g.prod, dev2"
}

variable "loc" {
    type        = "string"
    description = "Azure region shortname."
}

variable "address_prefix" {
    type        = "string"
    description = "For environment's subnet in existing vnet. CIDR notation, e.g. 10.0.1.0/24"
}

variable "tags" {
    type        = "map"
    default     = {}
    description = "Map of tag name:value pairs."
}