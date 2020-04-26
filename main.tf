provider "azurerm" {
    features {}
}

data "azurerm_resource_group" "this" {
  name = "cdearkland-hcs-rg"
}

data "azurerm_virtual_network" "this" {
  name                = "aks-demo-network"
  resource_group_name = data.azurerm_resource_group.this.name
}

data "azurerm_subnet" "this" {
  name                 = "hcsclientvm"
  virtual_network_name = data.azurerm_virtual_network.this.name
  resource_group_name  = data.azurerm_resource_group.this.name
}

resource "azurerm_network_security_group" "netallow" {
  name                = "allow-networks"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name

  security_rule {
    name                       = "networksAllow"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.0.0/16"
    destination_address_prefix = "*"
  }

}

resource "azurerm_network_interface" "this1" {
  name                = "externalnic"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.this.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.this1.id
  }
}

resource "azurerm_public_ip" "this1" {
  name                = "hcsweb01ip"
  location            = "West US 2"
  resource_group_name = data.azurerm_resource_group.this.name
  allocation_method   = "Static"
}


resource "azurerm_linux_virtual_machine" "hcsweb01" {
  name                = "hcsweb01"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  size                = "Standard_B1ms"
  admin_username      = "codyhc"
  network_interface_ids = [
    azurerm_network_interface.this1.id,
  ]

  admin_ssh_key {
    username   = "codyhc"
    public_key = var.sshkey
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_id = var.image
} 
