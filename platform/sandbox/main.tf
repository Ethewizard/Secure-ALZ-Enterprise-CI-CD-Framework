# ═══════════════════════════════════════════════════════════════
# SANDBOX VM — platform/sandbox/main.tf
# Destination: Tenant Root Group / Azure Landing Zones / Sandbox
# Resource Group: rg-sandbox
# ═══════════════════════════════════════════════════════════════

# ── Resource Group ────────────────────────────────────────────
resource "azurerm_resource_group" "sandbox" {
  name     = "rg-sandbox"
  location = var.default_location
  tags     = var.tags
}

# ── VNet & Subnet ─────────────────────────────────────────────
resource "azurerm_virtual_network" "sandbox" {
  name                = "vnet-sandbox"
  location            = var.default_location
  resource_group_name = azurerm_resource_group.sandbox.name
  address_space       = ["10.200.0.0/16"]
  tags                = var.tags
}

resource "azurerm_subnet" "sandbox" {
  name                 = "snet-default"
  resource_group_name  = azurerm_resource_group.sandbox.name
  virtual_network_name = azurerm_virtual_network.sandbox.name
  address_prefixes     = ["10.200.1.0/24"]
}

# ── NIC ───────────────────────────────────────────────────────
resource "azurerm_network_interface" "sandbox_vm" {
  name                = "nic-sandbox-vm"
  location            = var.default_location
  resource_group_name = azurerm_resource_group.sandbox.name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sandbox.id
    private_ip_address_allocation = "Dynamic"
  }
}

# ── VM ────────────────────────────────────────────────────────
resource "azurerm_linux_virtual_machine" "sandbox" {
  name                            = "vm-sandbox-test"
  location                        = var.default_location
  resource_group_name             = azurerm_resource_group.sandbox.name
  size                            = "Standard_B1s"
  admin_username                  = "azureuser"
  disable_password_authentication = false
  admin_password                  = "TEST"
  network_interface_ids           = [azurerm_network_interface.sandbox_vm.id]
  tags                            = var.tags

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
