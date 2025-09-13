module "resource_group" {
  source         = "../child/resourcegroup"
  resource_group = "hclrg1"
  location       = "East US"
}
module "storage_account" {
  source          = "../child/storageaccount"
  resource_group  = "hclrg1"
  location        = "francecentral"
  storage_account = "hclsa45626"
  depends_on      = [module.resource_group]
}

module "vnet" {
  source         = "../child/vnet"
  vnet_name      = "hcl-vnet"
  resource_group = "hclrg1"
  location       = "francecentral"
  address_space  = ["10.0.0.0/24"]
  depends_on     = [module.resource_group]
}

module "subnetfront" {
  source             = "../child/subnet"
  resource_group     = "hclrg1"
  vnet_name          = "hcl-vnet"
  address_prefixes1  = ["10.0.0.0/26"]   # subnet-front
  address_prefixes2  = ["10.0.0.64/26"]  # subnet-back
  address_prefixes3  = ["10.0.0.128/27"] # AzureBastionSubnet
  subnetfront_name   = "subnet-front"
  subnetbackend_name = "subnet-back"
  subnet_name        = "AzureBastionSubnet"
  depends_on         = [module.vnet]
}

module "vm_name" {
  source             = "../child/virtualmachine"
  resource_group     = "hclrg1"
  location           = "francecentral"
  vm_namef           = "hcl-vmf"
  vm_nameb           = "hcl-vmb"
  nic_namef          = "hcl-nicf"
  nic_nameb          = "hcl-nicb"
  subnetfront_name   = "subnet-front"
  subnetbackend_name = "subnet-back"
  vnet_name          = "hcl-vnet"
  depends_on         = [module.subnetfront]

}
module "public_ip" {
  source         = "../child/pip"
  resource_group = "hclrg1"
  location       = "francecentral"
  public_ip      = "hcl-pip"
  depends_on     = [module.resource_group, module.vm_name]

}
module "bastion_name" {
  source         = "../child/bastiion"
  resource_group = "hclrg1"
  location       = "francecentral"
  bastion_name   = "hcl-bastion"
  vnet_name      = "hcl-vnet"
  subnet_name    = "AzureBastionSubnet"
  public_ip      = "hcl-pip"
  depends_on     = [module.public_ip, module.vm_name]

}