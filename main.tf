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

resource "azurerm_public_ip" "nomad1" {
  name                = "hcsnomad01ip"
  location            = "West US 2"
  resource_group_name = data.azurerm_resource_group.this.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "nomad1" {
  name                = "nomadext01"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.this.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.nomad1.id
  }
}

resource "azurerm_linux_virtual_machine" "hcsnomad01" {
  name                = "hcsnomad01"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  size                = "Standard_B1ms"
  admin_username      = "codyhc"
  network_interface_ids = [
    azurerm_network_interface.nomad1.id,
  ]

  admin_ssh_key {
    username   = "codyhc"
    public_key = var.sshkey
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_id = var.nomadimage
} 

resource "azurerm_public_ip" "nomad2" {
  name                = "hcsnomad02ip"
  location            = "West US 2"
  resource_group_name = data.azurerm_resource_group.this.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "nomad2" {
  name                = "nomadext2"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.this.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.nomad2.id
  }
}

resource "azurerm_linux_virtual_machine" "hcsnomad02" {
  name                = "hcsnomad02"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  size                = "Standard_B1ms"
  admin_username      = "codyhc"
  network_interface_ids = [
    azurerm_network_interface.nomad2.id,
  ]

  admin_ssh_key {
    username   = "codyhc"
    public_key = var.sshkey
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_id = var.nomadimage
} 

resource "azurerm_public_ip" "nomad3" {
  name                = "hcsnomad03ip"
  location            = "West US 2"
  resource_group_name = data.azurerm_resource_group.this.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "nomad3" {
  name                = "nomadext03"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.this.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.nomad3.id
  }
}

resource "azurerm_linux_virtual_machine" "hcsnomad03" {
  name                = "hcsnomad03"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  size                = "Standard_B1ms"
  admin_username      = "codyhc"
  network_interface_ids = [
    azurerm_network_interface.nomad3.id,
  ]

  admin_ssh_key {
    username   = "codyhc"
    public_key = var.sshkey
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_id = var.nomadimage
} 

resource "azurerm_public_ip" "nomadclient1" {
  name                = "hcsnomadcl01ip"
  location            = "West US 2"
  resource_group_name = data.azurerm_resource_group.this.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "nomadcl01" {
  name                = "nomadclext01"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.this.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.nomadclient1.id
  }
}

resource "azurerm_linux_virtual_machine" "hcsnomadcl01" {
  name                = "hcsnomadcl01"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  size                = "Standard_B1ms"
  admin_username      = "codyhc"
  network_interface_ids = [
    azurerm_network_interface.nomadcl01.id,
  ]

  admin_ssh_key {
    username   = "codyhc"
    public_key = var.sshkey
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_id = var.nomadclientimage
} 

resource "azurerm_public_ip" "nomadclient2" {
  name                = "hcsnomadcl02ip"
  location            = "West US 2"
  resource_group_name = data.azurerm_resource_group.this.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "nomadcl02" {
  name                = "nomadclext02"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.this.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.nomadclient2.id
  }
}

resource "azurerm_linux_virtual_machine" "hcsnomadcl02" {
  name                = "hcsnomadcl02"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  size                = "Standard_B1ms"
  admin_username      = "codyhc"
  network_interface_ids = [
    azurerm_network_interface.nomadcl02.id,
  ]

  admin_ssh_key {
    username   = "codyhc"
    public_key = var.sshkey
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_id = var.nomadclientimage
} 

resource "azurerm_public_ip" "nomadclient3" {
  name                = "hcsnomadcl03ip"
  location            = "West US 2"
  resource_group_name = data.azurerm_resource_group.this.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "nomadcl03" {
  name                = "nomadclext03"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.this.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.nomadclient3.id
  }
}

resource "azurerm_linux_virtual_machine" "hcsnomadcl03" {
  name                = "hcsnomadcl03"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  size                = "Standard_B1ms"
  admin_username      = "codyhc"
  network_interface_ids = [
    azurerm_network_interface.nomadcl03.id,
  ]

  admin_ssh_key {
    username   = "codyhc"
    public_key = var.sshkey
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_id = var.nomadclientimage
} 
