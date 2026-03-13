data "opentelekomcloud_identity_project_v3" "current" {}

resource "opentelekomcloud_identity_user_v3" "user" {
  name        = var.name
  description = local.description
  enabled     = true
  pwd_reset   = null
  lifecycle {
    ignore_changes = [pwd_reset]
  }
}

data "opentelekomcloud_identity_role_v3" "roles" {
  for_each = var.roles
  name     = each.key
}

# Fetch this information only, when the group is already existing...
data "opentelekomcloud_identity_group_v3" "group" {
  count = var.create_group ? 0 : 1

  name = var.name
}

# ... otherwise create the group and assign a role to it
resource "opentelekomcloud_identity_group_v3" "group" {
  count = var.create_group ? 1 : 0

  name        = var.name
  description = local.description
}

locals {
  group_id = var.create_group ? opentelekomcloud_identity_group_v3.group[0].id : data.opentelekomcloud_identity_group_v3.group[0].id
}

resource "opentelekomcloud_identity_role_assignment_v3" "role_to_group" {
  for_each = data.opentelekomcloud_identity_role_v3.roles

  group_id   = local.group_id
  role_id    = each.value.id
  project_id = data.opentelekomcloud_identity_project_v3.current.id
}

# Add the user to the new or existing group
resource "opentelekomcloud_identity_group_membership_v3" "user_to_group" {
  group = local.group_id
  users = [opentelekomcloud_identity_user_v3.user.id]
}

# Create credentials for the user
resource "opentelekomcloud_identity_credential_v3" "user_aksk" {
  user_id     = opentelekomcloud_identity_user_v3.user.id
  description = local.description
}
