# OTC Project-Scoped User

Creates a programmatic IAM user in OTC scoped to the current project, along with an IAM group, OTC role assignments, and AK/SK credentials ready to use.

> **Note:** "Project-scoped" means role assignments are limited to the OTC project the provider is configured for. The user has no permissions outside that project.

## How it works

1. **IAM user** — a new OTC IAM user is created with the given name.
2. **IAM group** — a new IAM group is created (or an existing one is reused if `create_group = false`) with the same name.
3. **Role assignments** — each role in `var.roles` is looked up by name and assigned to the group at the project level.
4. **Group membership** — the user is added to the group, inheriting its role assignments.
5. **AK/SK credentials** — an Access Key / Secret Key pair is generated for the user and exposed as sensitive outputs, ready to be written to Vault or another secret store.

## Usage example

```hcl
module "my_service_user" {
  source = "../../../modules-new/otc-project-scoped-user"
  name   = "${var.context}-${var.stage}-my-service"
  roles  = ["system_all_60"]
}

resource "vault_generic_secret" "my_service_credentials" {
  path = "${local.vault_kv_mount_path}/${var.stage}/my-service/otc_credentials"
  data_json = jsonencode({
    access_key = module.my_service_user.access_key
    secret_key = module.my_service_user.secret_key
    project_id = module.my_service_user.project_id
  })
}
```

### Using an existing OTC group

If you want to assign the user to one of OTC's built-in groups instead of creating a new one, set `create_group = false`. The module will look up the group by `var.name` and assign the roles to it:

```hcl
module "my_service_user" {
  source       = "../../../modules-new/otc-project-scoped-user"
  name         = "existing-group-name"
  roles        = ["system_all_60"]
  create_group = false
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_opentelekomcloud"></a> [opentelekomcloud](#requirement\_opentelekomcloud) | ~> 1.36 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_opentelekomcloud"></a> [opentelekomcloud](#provider\_opentelekomcloud) | ~> 1.36 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [opentelekomcloud_identity_credential_v3.user_aksk](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/identity_credential_v3) | resource |
| [opentelekomcloud_identity_group_membership_v3.user_to_group](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/identity_group_membership_v3) | resource |
| [opentelekomcloud_identity_group_v3.group](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/identity_group_v3) | resource |
| [opentelekomcloud_identity_role_assignment_v3.role_to_group](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/identity_role_assignment_v3) | resource |
| [opentelekomcloud_identity_user_v3.user](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/identity_user_v3) | resource |
| [opentelekomcloud_identity_group_v3.group](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/data-sources/identity_group_v3) | data source |
| [opentelekomcloud_identity_project_v3.current](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/data-sources/identity_project_v3) | data source |
| [opentelekomcloud_identity_role_v3.roles](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/data-sources/identity_role_v3) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_group"></a> [create\_group](#input\_create\_group) | Can be used to disable creation of a group and assign the user and the roles to an existing one. | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the created resources. Default: "Created by terraform for user/group <var.name> with roles: <var.roles>." | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for the OTC resources being created. | `string` | n/a | yes |
| <a name="input_roles"></a> [roles](#input\_roles) | Roles assigned to the user/group. Roles must exist and be within the same project scope as the provider. | `set(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_key"></a> [access\_key](#output\_access\_key) | Access key for authenticating with the created user. |
| <a name="output_group_id"></a> [group\_id](#output\_group\_id) | ID of the created group. If var.create\_group is set to false, it will passthrough the ID of the existing group. |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | ID of the OTC project the user and roles are scoped to. |
| <a name="output_secret_key"></a> [secret\_key](#output\_secret\_key) | Secret key for authenticating with the created user. |
| <a name="output_user_id"></a> [user\_id](#output\_user\_id) | ID of the created user. |
<!-- END_TF_DOCS -->
