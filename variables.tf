variable "name" {
  type        = string
  description = "Name for the OTC resources being created."
}

variable "description" {
  type        = string
  description = "Description of the created resources. Default: \"Created by terraform for user/group <var.name> with roles: <var.roles>.\""
  default     = null
}

locals {
  default_description = "Created by terraform for user/group ${var.name} with roles: [${join(", ", var.roles)}]."
  description         = var.description == null ? local.default_description : var.description
}

variable "roles" {
  type        = set(string)
  description = "Roles assigned to the user/group. Roles must exist and be within the same project scope as the provider."
}

variable "create_group" {
  type        = bool
  description = "Can be used to disable creation of a group and assign the user and the roles to an existing one."
  default     = true
}
