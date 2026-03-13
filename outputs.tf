output "access_key" {
  sensitive   = true
  value       = opentelekomcloud_identity_credential_v3.user_aksk.access
  description = "Access key for authenticating with the created user."
}

output "secret_key" {
  sensitive   = true
  value       = opentelekomcloud_identity_credential_v3.user_aksk.secret
  description = "Secret key for authenticating with the created user."
}

output "user_id" {
  value       = opentelekomcloud_identity_user_v3.user.id
  description = "ID of the created user."
}

output "group_id" {
  value       = local.group_id
  description = "ID of the created group. If var.create_group is set to false, it will passthrough the ID of the existing group."
}

output "project_id" {
  value       = data.opentelekomcloud_identity_project_v3.current.id
  description = "ID of the OTC project the user and roles are scoped to."
}
