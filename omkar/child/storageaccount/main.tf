resource "azurerm_storage_account" "sa8" {
    name                     = var.storage_account
    resource_group_name      = var.resource_group
    location                 = var.location
    account_tier             = "Standard"
    account_replication_type = "LRS"
}
