provider "azurerm" {
    version = "~> 1.22"
}

locals {
    env = "${var.project}-${var.environment_name}"
}

data "azurerm_image" "ubuntu" {
  name                = "ubuntu"
  resource_group_name = "images"
}

resource "azurerm_subnet" "env" {
  name                 = "${local.env}"
  virtual_network_name = "${var.project}-vnet"
  resource_group_name  = "${var.project}-core"
  address_prefix       = "${var.address_prefix}"
}

resource "azurerm_resource_group" "env" {
    name        = "${local.env}"
    location    = "${var.loc}"
    tags        = "${var.tags}"
}

resource "azurerm_network_security_group" "env" {
    name                = "${local.env}-nsg"
    resource_group_name = "${azurerm_resource_group.env.name}"
    location            = "${azurerm_resource_group.env.location}"
    tags                = "${azurerm_resource_group.env.tags}"
}

resource "azurerm_application_security_group" "web" {
    name                = "${local.env}-asg-web"
    resource_group_name = "${azurerm_resource_group.env.name}"
    location            = "${azurerm_resource_group.env.location}"
    tags                = "${azurerm_resource_group.env.tags}"
}

resource "azurerm_application_security_group" "logic" {
    name                = "${local.env}-asg-logic"
    resource_group_name = "${azurerm_resource_group.env.name}"
    location            = "${azurerm_resource_group.env.location}"
    tags                = "${azurerm_resource_group.env.tags}"
}

resource "azurerm_network_security_rule" "web2logic" {
    name                        = "${local.env}-web2logic"
    network_security_group_name = "${azurerm_network_security_group.env.name}"
    resource_group_name         = "${azurerm_resource_group.env.name}"

    priority                    = 100
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_ranges     = [ "80", "8080", "443" ]

    source_application_security_group_ids      = [ "${azurerm_application_security_group.web.id}" ]
    destination_application_security_group_ids = [ "${azurerm_application_security_group.logic.id}" ]
}

module "web" {
    source = "../pcms-module-vmss" // change to GitHub reference when stable

    project             = "${var.project}"
    environment_name    = "${var.environment_name}"
    prefix              = "web"

    subnet_id           = "${azurerm_subnet.env.id}"
    asg_id              = "${azurerm_application_security_group.web.id}"

    vmmin               = 1
    vmmax               = 10
}

module "logic" {
    source = "../pcms-module-vmss" // change to GitHub reference when stable

    project             = "${var.project}"
    environment_name    = "${var.environment_name}"
    prefix              = "logic"

    subnet_id           = "${azurerm_subnet.env.id}"
    asg_id              = "${azurerm_application_security_group.logic.id}"

    image_id            = "${data.azurerm_image.ubuntu.id}"
    vmmin               = 1
    vmmax               = 5
}
