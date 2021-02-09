terraform {
  required_providers {
    azuredevops = {
      source = "microsoft/azuredevops"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = ">= 0.13"
  backend "azurerm" {}
}

provider "azuredevops" {
  org_service_url       = var.org_service_url
  personal_access_token = var.personal_access_token
}

variable "org_service_url" {
  type      = string
}

variable "personal_access_token" {
  type      = string
}

resource "azuredevops_project" "project" {
  name       = "Test Project"
  description        = "Test Project Description"
  visibility         = "private"
  version_control    = "Git"
  work_item_template = "Agile"

  features = {
      "testplans" = "disabled"
      "artifacts" = "disabled"
  }
}

module "demo-module-usage" {
  source               = "./module/Foundry-Azure-DevOps-Project"
  azure_devops_project = {
    name               = "Module Issue Demo", //default project name
    areaPrefix         = "Issue"
    subscription_id    = "10737489-ac39-415a-bd96-e76f05732c85"
    description        = "example" // change as required
    visibility         = "private",
    vnetRange          = "10.0.0.1/20", // range to be used for core
    subnetCount        = "8",           //how many subnets to generate. 
    subnetExtraBits    = "4",           //how many bits to add to the CIDR of the parent. 1 with /23 would be /24                                                                  //private or public - suggest private for THIS repo
    version_control    = "git"          // git or tfvc 
    work_item_template = "Agile"
    repolist           = ["Azure-Cloud-Foundry-Projects", "Azure-Cloud-Foundry-ManagementGroups", "Azure-Cloud-Foundry-Other"]
    features = {
      boards       = "enabled" //optional
      repositories = "enabled" //required enabled for this codebase to work
      pipelines    = "enabled" //required enabled for this codebase to work
      testplans    = "enabled" //optional
      artifacts    = "enabled" //optional
    }
  }
}

