resource "azurerm_virtual_network" "dt-demo" {
  name                = "${var.prefix}-network"
  location            = var.location
  resource_group_name = azurerm_resource_group.dt-demo.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "dt-demo-subnet1" {
  name                 = "${var.prefix}-internal-1"
  resource_group_name  = azurerm_resource_group.dt-demo.name
  virtual_network_name = azurerm_virtual_network.dt-demo.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "dt-demo-interface1" {
  name                      = "${var.prefix}-instance-1"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.dt-demo.name
  #network_security_group_id = azurerm_network_security_group.allow-ssh.id

  ip_configuration {
    name                          = "instance-1"
    subnet_id                     = azurerm_subnet.dt-demo-subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.dt-demo-ip1.id
  }
}

resource "azurerm_network_security_group" "allow-ssh" {
  name                = "${var.prefix}-allow-ssh"
  location            = var.location
  resource_group_name = azurerm_resource_group.dt-demo.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.ssh-source-address
    destination_address_prefix = "*"
  }
    security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = var.ssh-source-address
    destination_address_prefix = "*"
}

  tags = {
    environment = "dt-demo"
  }
}

resource "azurerm_network_interface_security_group_association" "dt-demo-sec-assoc1" {
  network_interface_id      = azurerm_network_interface.dt-demo-interface1.id
  network_security_group_id = azurerm_network_security_group.allow-ssh.id
}

resource "azurerm_subnet" "dt-demo-subnet2" {
  name                 = "${var.prefix}-internal-2"
  resource_group_name  = azurerm_resource_group.dt-demo.name
  virtual_network_name = azurerm_virtual_network.dt-demo.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_network_interface" "dt-demo-interface2" {
  name                      = "${var.prefix}-instance-2"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.dt-demo.name
  #network_security_group_id = azurerm_network_security_group.allow-ssh.id

  ip_configuration {
    name                          = "instance-2"
    subnet_id                     = azurerm_subnet.dt-demo-subnet2.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.dt-demo-ip2.id
  }
}

resource "azurerm_network_interface_security_group_association" "dt-demo-sec-assoc2" {
  network_interface_id      = azurerm_network_interface.dt-demo-interface2.id
  network_security_group_id = azurerm_network_security_group.allow-ssh.id
}