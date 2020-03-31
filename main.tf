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

resource "azurerm_network_interface" "example" {
  name                = "externalnic"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.this.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.this.id
  }
}

resource "azurerm_public_ip" "this" {
  name                = "hcsclient04ip"
  location            = "West US 2"
  resource_group_name = data.azurerm_resource_group.this.name
  allocation_method   = "Static"
}

resource "azurerm_linux_virtual_machine" "hcsclient04" {
  name                = "hcsclient04"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  size                = "Standard_B1ms"
  admin_username      = "codyhc"
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  admin_ssh_key {
    username   = "codyhc"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDZWetJdpOowRmu5PeaYbKK9WPKiC3w5cB1PpVGZZwKuSczAUYBmJTYBnv5Hs4c5Iz0j/87fqqEoFuwPv1E08r69EqbgmTdREBxTm+7lzCTsPCMo4G4DZFWwUwd+ZarA7j22f0Mik2iUOMWml3BUemvymYXwO9unwwkFRvCaWtXNtIEVimLms1ILCMld4MolXgyIwpfR3uXDCCcPjIHnAXOD0ziuZQ7x9WG6I9d/kO1JiYaa3sDWNkjQiP7qcp8OjMV6sTuE+1xljDDfgf8Ze8vJNdLauFGDX6sm8Cw1E49Qhg5Jc0fzjJVkLV8zkFOWF0Vp777m5oE2sjOVCQjLKx/I6529v53C5Wm5e8bgmPkjaPiJUTvH27NEuJqFI1TDPEapm/s5pBFxVlTndYILojWxuozrFusaIBC4z6DcV9dVpHFBb6zIQDlWH8W0jlsoKFKE4JS8qmI2pWWK/e4za3SGZOH+KZqetXK5i7u8633xGZt0pIcjUP4rozzLrlO8QIGVtUITnRzdrkTu+gHPxTkRoKgpnO5xIAajnWQ1M8VUdymCGCiTast9WTFkHg6GYlcBV8FK+2ALDbKKbESZn/qcLdFDE5BKtI3eHomuENvTQr+q2MjsczaolomLKhgUcMRMmIxOVaOM0czAuMd1tiVIBqOu3U3NhywOgJITX/saw=="
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_id = "/subscriptions/2835f892-3393-4988-bf4b-c169a8b22f1e/resourceGroups/cdearkland-hcs-rg/providers/Microsoft.Compute/images/consul-hcs-cde"
} 