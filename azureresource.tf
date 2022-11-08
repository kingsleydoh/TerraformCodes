resource "azurerm_resource_group" "lab_test" {
  name     = "lab101"
  location = "East US 2"
}

resource "azurerm_virtual_network" "labnetwork" {
  name                = "labnetwork"
  resource_group_name = azurerm_resource_group.lab_test.name
  location            = "East US 2"
  address_space       = ["192.0.0.0/16"]
}
resource "azurerm_subnet" "labsub" {
  name                 = "labsubnet"
  resource_group_name  = azurerm_resource_group.lab_test.name
  virtual_network_name = azurerm_virtual_network.labnetwork.name
  address_prefixes     = ["192.0.0.0/24"]
}

resource "azurerm_network_interface" "labInt" {
  name                = "labint"
  resource_group_name = azurerm_resource_group.lab_test.name
  location            = azurerm_resource_group.lab_test.location
  ip_configuration {
    name                          = "labintface"
    subnet_id                     = azurerm_subnet.labsub.id
    private_ip_address            = "Dynamic"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.labpip.id
  }

}

resource "azurerm_public_ip" "labpip" {
  name                = "publicIp"
  location            = azurerm_resource_group.lab_test.location
  resource_group_name = azurerm_resource_group.lab_test.name
  allocation_method   = "Dynamic"
  ip_version          = "IPv4"
}

resource "azurerm_linux_virtual_machine" "labvm" {
  disable_password_authentication = "false"
  name                  = "labtestvm"
  admin_username        = "kingsley"
  admin_password        = "Pa$$w0rd0000"
  resource_group_name   = azurerm_resource_group.lab_test.name
  location              = azurerm_resource_group.lab_test.location
  size                  = "standard_f2"
  network_interface_ids = [azurerm_network_interface.labInt.id, ]

  os_disk {
    name                 = "labvm"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

