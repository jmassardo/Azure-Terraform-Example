# Setup the infrastructure components required to create the environment

# Create a resource group to contain all the objects
resource "azurerm_resource_group" "rg" {
  name     = "Webserver_rg"
  location = "Central US"
}

# Create the virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "Webserver_Network"
  address_space       = ["10.0.0.0/16"]
  location            = "Central US"
  resource_group_name = "${azurerm_resource_group.rg.name}"
}

# Create the individual subnet for the web servers
resource "azurerm_subnet" "subnet" {
  name                 = "Webserver_Subnet"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "10.0.1.0/24"
}

# create the network security group to allow inbound access to the server
resource "azurerm_network_security_group" "nsg" {
  name                = "Webserver_nsg"
  location            = "Central US"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  
  # create a rule to allow HTTPS inbound to all nodes in the network
  security_rule {
    name                       = "Allow_HTTPS"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  
  # create a rule to allow SSH inbound to all nodes in the network. Note the priority. All rules but have a unique priority
  security_rule {
    name                       = "Allow_SSH"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  
  # add an environment tag. 
  tags {
    environment = "Production"
  }
}