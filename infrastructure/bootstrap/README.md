# Bootstrap Remote State Setup

This directory contains Terraform configuration to set up S3 backend and DynamoDB locking for state management.

## What Gets Created

1. **S3 Bucket** (`terraform-state-eu-west-1-eran`):
   - Stores Terraform state files
   - Versioning enabled for rollback capability
   - Server-side encryption (AES256)
   - Public access blocked for security

2. **DynamoDB Table** (`terraform-locks`):
   - Enables state locking during operations
   - Prevents concurrent modifications
   - Pay-per-request billing

## Setup Steps

### Step 1: Initialize and Deploy Bootstrap Backend

Navigate to the bootstrap directory and deploy these resources:

```powershell
cd bootstrap
terraform init
terraform plan
terraform apply
```

### Step 2: Configure Backend in Main Project

Once bootstrap is complete, the main project's `backend.tf` is already configured to use:
- S3 bucket: `terraform-state-eu-west-1-eran`
- DynamoDB table: `terraform-locks`
- Region: `eu-west-1`

Navigate back to the root and reinitialize:

```powershell
cd ..
terraform init

# When prompted, confirm migration of state to S3:
# "Do you want to copy existing state to the new backend?" → Yes
```

### Step 3: Verify Remote State

```powershell
terraform state list
```

## Notes

- **S3 Bucket Name**: Must be globally unique. If `eran-terraform-state` already exists, update the name in:
  - `bootstrap/main.tf`
  - `backend.tf`

- **State Locking**: Automatically engaged during `terraform apply/destroy`
  - Prevents concurrent modifications
  - Lock timeout: 0 (waits indefinitely)

- **Backup & Recovery**: 
  - S3 versioning enabled - can rollback to previous state versions
  - Always pull state before major changes: `terraform state pull > backup.tfstate`

## Security Best Practices

- ✅ Encryption at rest (S3 + DynamoDB)
- ✅ Public access blocked
- ✅ Versioning enabled
- ✅ Consider adding bucket policy to restrict access
- ✅ Enable MFA delete for additional safety (optional)

## Cleanup

To remove remote state setup (not recommended for production):

```powershell
cd bootstrap
terraform destroy
```

Then remove `backend.tf` from the main project and run `terraform init` again to use local state.
