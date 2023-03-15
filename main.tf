terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.29.0"
    }
  }
}
provider "azurerm" {
    features {
      
    }
  subscription_id = var.subscription_id
  client_id = var.client_id
  client_secret = var.client_secret
  tenant_id = var.tenant_id

}

resource "azurerm_resource_group" "newresourcegroup567" {
  name     = "newresources"
  location = "West Europe"
  tags = {
     "name" = "newresource"
  }
}
resource "azurerm_virtual_network" "resourcenetwork567" {
  name                = "resourcenetwork"
  resource_group_name = azurerm_resource_group.newresourcegroup567.name
  location            = azurerm_resource_group.newresourcegroup567.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "resource-websubnet567" {
  name                 = "resourcewebsubnet"
  resource_group_name  = azurerm_resource_group.newresourcegroup567.name
  virtual_network_name = azurerm_virtual_network.resourcenetwork567.name
  address_prefixes     = ["10.0.1.0/24"]

}
resource "azurerm_subnet" "resource-appsubnet567" {
  name                 = "resourceappsubnet"
  resource_group_name  = azurerm_resource_group.newresourcegroup567.name
  virtual_network_name = azurerm_virtual_network.resourcenetwork567.name
  address_prefixes     = ["10.0.2.0/24"]

}
resource "azurerm_subnet" "resource-dbsubnet567" {
  name                 = "resourcewebdbsubnet"
  resource_group_name  = azurerm_resource_group.newresourcegroup567.name
  virtual_network_name = azurerm_virtual_network.resourcenetwork567.name
  address_prefixes     = ["10.0.3.0/24"]

}
resource "azurerm_public_ip" "resourcepublicip567" {
  name                = "resourcepublicip"
  resource_group_name = azurerm_resource_group.newresourcegroup567.name
  location            = azurerm_resource_group.newresourcegroup567.location
  allocation_method   = "Static"

}
resource "azurerm_network_interface" "resourcenic567" {
  name                = "resource-nic"
  location            = azurerm_resource_group.newresourcegroup567.location
  resource_group_name = azurerm_resource_group.newresourcegroup567.name

  ip_configuration {
    name                          = "external"
    subnet_id                     = azurerm_subnet.resource-websubnet567.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.resourcepublicip567.id
  }
}
resource "azurerm_linux_virtual_machine" "resourcevm567" {
  name                = "resourcevm"
  resource_group_name = azurerm_resource_group.newresourcegroup567.name
  location            = azurerm_resource_group.newresourcegroup567.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.resourcenic567.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }
    os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}





