#create a public IP address for the virtual machine
resource "azurerm_public_ip" "webserver_pubip" {
  name                         = "webserver_pubip"
  location                     = "Central US"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  public_ip_address_allocation = "dynamic"

  tags {
    environment = "Production"
  }
}

#create the network interface and put it on the proper vlan/subnet
resource "azurerm_network_interface" "webserver_ip" {
  name                = "webserver_ip"
  location            = "Central US"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  ip_configuration {
    name                          = "webserver_ipconf"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.webserver_pubip.id}"
  }
}

#create the actual VM
resource "azurerm_virtual_machine" "webserver" {
  name                  = "webserver"
  location              = "Central US"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.webserver_ip.id}"]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "webserver_osdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "webserver"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags {
    environment = "staging"
  }
}