# Terraform Commands Cheatsheet

## Initialize
```bash
terraform init
```

## Preview Terraform Actions
```bash
terraform plan
```

## Apply Configuration with Variables
```bash
terraform apply -var-file terraform-dev.tfvars
```

## Destroy a Single Resource
```bash
terraform destroy -target aws_vpc.myapp-vpc
```

## Destroy Everything from TF Files
```bash
terraform destroy
```

## Show Resources and Components from Current State
```bash
terraform state list
```

## Show Current State of a Specific Resource/Data
```bash
terraform state show aws_vpc.myapp-vpc
```

## Set Custom TF Environment Variable (Before Apply)
```bash
export TF_VAR_avail_zone="ca-central-1"
```
