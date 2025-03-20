# Create a resource group
resource "azurerm_resource_group" "dtyryshkin-rg" {
  name     = "dtyryshkin-rg"
  location = "West Europe"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "dtyryshkin-vnet" {
  name                = "dtyryshkin-vnet"
  resource_group_name = azurerm_resource_group.dtyryshkin-rg.name
  location            = azurerm_resource_group.dtyryshkin-rg.location
  address_space       = ["11.0.0.0/16"]
}

# Define the subnet
resource "azurerm_subnet" "dtyryshkin-subnet" {
  name                 = "dtyryshkin-subnet"
  resource_group_name  = azurerm_resource_group.dtyryshkin-rg.name
  virtual_network_name = azurerm_virtual_network.dtyryshkin-vnet.name
  address_prefixes     = ["11.0.1.0/24"]
}


# Define the network interface
resource "azurerm_network_interface" "dtyryshkin-nic" {
  name                = "dtyryshkin-nic"
  location            = azurerm_resource_group.dtyryshkin-rg.location
  resource_group_name = azurerm_resource_group.dtyryshkin-rg.name

  ip_configuration {
    name                          = "public"
    subnet_id                     = azurerm_subnet.dtyryshkin-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Define the virtual machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "dtyryshkin-vm"
  location            = azurerm_resource_group.dtyryshkin-rg.location
  resource_group_name = azurerm_resource_group.dtyryshkin-rg.name
  network_interface_ids = [
    azurerm_network_interface.dtyryshkin-nic.id,
  ]
  size               = "Standard_DS1_v2"
  admin_username     = "username"
  admin_password     = "34FDA$#214f123"  # For demonstration purposes only. Use secure methods for production.
  disable_password_authentication = "false"

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