variable "epicbook_app" {
  type    = string
  description = "Azure VM Provisioned for a EpicBook App"
  default = "web-app"
}

variable "resource_group_name" {
  default = "epicbook-app-ansible"
}

variable "location" {
  default = "South Africa North"
}
