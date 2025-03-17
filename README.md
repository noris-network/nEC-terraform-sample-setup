# Terraform / OpenTofu with VMware Cloud Director sample setup

This example codebase shows a method of using Terraform / OpenTofu with [VMware Cloud Director](https://www.vmware.com/products/cloud-infrastructure/cloud-director).
Goal is, to devide the setup as much as possible for use with multiple teams as well as keeping the blast radius down to a minimum.
This codebase doesn't use any modules, instead uses plain resources from the [Terraform vCD provider](https://registry.terraform.io/providers/vmware/vcd/latest/docs).
This also sets an extremely low barrier to entry for newcomers to Terraform as well as this codebase.

If haven't purchased the AVI Loadbalancer feature you can simply delete any loadbalancer.tf files as well as the reference to the Service Engine Group in data.tf.

## How to find out names of resources (as of VMware Cloud Director 10.6)
* Edge Gateway names:
Networking -> Edge Gateways

* Cluster names:
Networking -> Datacenter Groups -> Your_DC_Group -> Participating VDCs

* Service Engine Group names:
Networking -> Edge Gateways -> Your_Edge_Gateway -> Loadbalancer -> Service Engine Groups

If there is no "Service Engine Groups" menu entry check if feature is enabled in "General Settings" of Loadbalancer

* Catalog names:
Content Hub -> Catalogs

* vApp image names:
Content Hub -> Catalogs -> Your_Catalog_Name -> vApp Templates

## Dependencies

The firewall part of the code depends on infrastructure as well as any departments.
The department parts of the code depend on infrastructure.

This means, to setup a complete infrastructure using this code one has to run terraform/tofu in the follwing order:

- ./infrastructure/
- ./department_1/*
- ./firewall/

# Terraform Backend Examples

It is strongly suggested to configure a remote backend for the terraform state.
The following are two examples.

## State in GitLab

Storing the state in GitLab uses [Terraform's http backend](https://developer.hashicorp.com/terraform/language/backend/http)
The GitLab terraform state feature is usually enabled by default.

### Backend configuration for GitLab

```terraform
terraform {
  backend "http" {
    address        = "https://gitlab.selfhosted.de/api/v4/projects/<GITLAB_PROJECT_ID>/terraform/state/<CUSTOM_STATE_NAME>"
    lock_address   = "https://gitlab.selfhosted.de/api/v4/projects/<GITLAB_PROJECT_ID>/terraform/state/<CUSTOM_STATE_NAME>/lock"
    unlock_address = "https://gitlab.selfhosted.de/api/v4/projects/<GITLAB_PROJECT_ID>/terraform/state/<CUSTOM_STATE_NAME>/lock"
    lock_method    = "POST"
    unlock_method  = "DELETE"
  }
}
```

## State in selfhosted S3 Bucket

Storing the state in an S3 bucket uses [Terraforms S3 backend](https://developer.hashicorp.com/terraform/language/backend/s3)

### Create Bucket

Suggestion: Use s3cmd to create your S3 buckets.

Edit ~/.s3cfg

```ini
access_key = <access_key>
secret_key = <secret_key>
host_base = https://s3-storage.selfhosted.de
use_https = True
host_bucket = %(bucket).https://s3-storage.selfhosted.de
```
```bash
s3cmd -c ~/.s3cfg mb "<BUCKET_NAME>"
```

### Backend configuration for S3 buckets

```terraform
terraform {
  backend "s3" {
      bucket = "<BUCKET_NAME>"
      endpoints = {
          s3 = "https://s3-storage.selfhosted.de"
      }
      key = "<CUSTOM_STATE_NAME>.tfstate"

      access_key="<access_key>"
      secret_key="<secret_key>"

      region = "us-east-3" # Region validation will be skipped, mandatory parameter
      skip_credentials_validation = true
      skip_requesting_account_id = true
      skip_metadata_api_check = true
      skip_region_validation = true
      use_path_style = true
  }
}
```

This also needs to have AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY exported on the console.

# Using OpenTufo / Terraform

## Export Environment vars

### Linux

```bash
! export VCD_API_TOKEN="<Cloud Director API Token>"
```

### Windows

```powershell
!$env:VCD_API_TOKEN = '<Cloud Director API Token>'
```

## Run tofu

```bash
tofu init
```

This will initialise remote state, download modules and providers.

## Make changes

Modify the Terraform code and apply the changes:

```bash
tofu plan -out tfplan
tofu apply tfplan
```

This will apply all needed changes to the infrastructure.
