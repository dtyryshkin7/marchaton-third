# Create a resource group
# This is the logical container for all the resources in Azure.
resource "azurerm_resource_group" "dtyryshkin-rg" {
  name     = "dtyryshkin-rg"  # Name of the resource group
  location = "West Europe"    # Azure region where the resources will be deployed
}

# Create a virtual network within the resource group
# A virtual network is used to define the network space for resources.
resource "azurerm_virtual_network" "dtyryshkin-vnet" {
  name                = "dtyryshkin-vnet"  # Name of the virtual network
  resource_group_name = azurerm_resource_group.dtyryshkin-rg.name  # Reference to the resource group
  location            = azurerm_resource_group.dtyryshkin-rg.location  # Location of the virtual network
  address_space       = ["11.0.0.0/16"]  # CIDR block defining the address space for the virtual network
}

# Define the subnet
# A subnet is a smaller network within the virtual network.
resource "azurerm_subnet" "dtyryshkin-subnet" {
  name                 = "dtyryshkin-subnet"  # Name of the subnet
  resource_group_name  = azurerm_resource_group.dtyryshkin-rg.name  # Reference to the resource group
  virtual_network_name = azurerm_virtual_network.dtyryshkin-vnet.name  # Reference to the virtual network
  address_prefixes     = ["11.0.1.0/24"]  # CIDR block defining the address space for the subnet
}

# Define the network interface
# A network interface connects a virtual machine to the virtual network.
resource "azurerm_network_interface" "dtyryshkin-nic" {
  name                = "dtyryshkin-nic"  # Name of the network interface
  location            = azurerm_resource_group.dtyryshkin-rg.location  # Location of the network interface
  resource_group_name = azurerm_resource_group.dtyryshkin-rg.name  # Reference to the resource group

  ip_configuration {
    name                          = "public"  # Name of the IP configuration
    subnet_id                     = azurerm_subnet.dtyryshkin-subnet.id  # Reference to the subnet
    private_ip_address_allocation = "Dynamic"  # Private IP address is dynamically assigned
  }
}

# Define the virtual machine
# A virtual machine is a compute resource in Azure.
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "dtyryshkin-vm"  # Name of the virtual machine
  location            = azurerm_resource_group.dtyryshkin-rg.location  # Location of the virtual machine
  resource_group_name = azurerm_resource_group.dtyryshkin-rg.name  # Reference to the resource group
  network_interface_ids = [
    azurerm_network_interface.dtyryshkin-nic.id,  # Reference to the network interface
  ]
  size               = "Standard_DS1_v2"  # Size of the virtual machine
  admin_username     = "username"  # Administrator username for the virtual machine
  admin_password     = "34FDA$#214f123"  # Administrator password (use secure methods in production)
  disable_password_authentication = "false"  # Password authentication is enabled

  os_disk {
    caching              = "ReadWrite"  # Disk caching mode
    storage_account_type = "Standard_LRS"  # Storage type for the OS disk
  }

  source_image_reference {
    publisher = "Canonical"  # Publisher of the image
    offer     = "UbuntuServer"  # Offer name
    sku       = "18.04-LTS"  # SKU of the image
    version   = "latest"  # Use the latest version of the image
  }
}