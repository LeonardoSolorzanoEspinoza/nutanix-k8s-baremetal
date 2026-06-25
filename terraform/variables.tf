variable "nutanix_user" {
  description = "Nutanix Prism username"
  type        = string
}

variable "nutanix_password" {
  description = "Nutanix Prism password"
  type        = string
  sensitive   = true
}

variable "nutanix_endpoint" {
  description = "Nutanix Prism endpoint IP or FQDN"
  type        = string
}

variable "cluster_uuid" {
  description = "UUID of the target Nutanix cluster"
  type        = string
}

variable "subnet_uuid" {
  description = "UUID of the subnet used by Kubernetes VMs"
  type        = string
}

variable "image_uuid" {
  description = "UUID of the VM image (for example Ubuntu cloud image)"
  type        = string
}

variable "ssh_public_key" {
  description = "Public SSH key injected into provisioned VMs"
  type        = string
}