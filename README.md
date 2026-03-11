# Terraform AWS Infrastructure

A modular Terraform project that provisions a complete AWS environment including VPC, subnet, internet gateway, security groups, and an EC2 instance running Docker and Nginx.

---

## Project Structure

```
terraform-learning/
├── main.tf                          
├── variables.tf                     
├── outputs.tf                       
├── terraform.tfvars                 
└── modules/
    ├── subnet/
    │   ├── main.tf                  
    │   ├── variables.tf
    │   └── outputs.tf
    └── webserver/
        ├── main.tf                  
        ├── variables.tf
        ├── outputs.tf
        └── entry-script.sh         
```

---

## File Descriptions

### Root Files

| File | Description |
|---|---|
| `main.tf` | Root module — defines VPC and calls subnet and webserver modules |
| `variables.tf` | All input variable declarations for the root module |
| `outputs.tf` | Outputs exposed from the root module e.g. EC2 public IP |
| `terraform.tfvars` | Variable values — not committed to git |

### `modules/subnet/`

| File | Description |
|---|---|
| `main.tf` | Subnet, internet gateway and default route table |
| `variables.tf` | Input variables for the subnet module |
| `outputs.tf` | Outputs the subnet ID back to the root module |

### `modules/webserver/`

| File | Description |
|---|---|
| `main.tf` | Security group, AMI data source, key pair and EC2 instance |
| `variables.tf` | Input variables for the webserver module |
| `outputs.tf` | Outputs EC2 public IP and AMI ID back to root |
| `entry-script.sh` | User data script — installs Docker and runs Nginx on port 8080 |

---

## Architecture

```
Internet
    │
    ▼
Internet Gateway
    │
    ▼
VPC (10.0.0.0/16)
    │
    ▼
Public Subnet (10.0.10.0/24) — ca-central-1a
    │
    ▼
Security Group
  ├── Ingress: Port 22   (SSH)  — your IP only
  ├── Ingress: Port 8080 (HTTP) — open to all
  └── Egress:  All traffic — open
    │
    ▼
EC2 Instance (Amazon Linux 2023 — t3.micro)
    └── Docker → Nginx on port 8080
```

---

## Prerequisites

- Terraform >= 1.0
- AWS CLI configured with valid credentials
- SSH key pair on your local machine
- A `terraform.tfvars` file with all required variables

---

## Input Variables

| Variable | Type | Description |
|---|---|---|
| `vpc_cidr_block` | string | CIDR block for the VPC e.g. `10.0.0.0/16` |
| `subnet_cidr_block` | string | CIDR block for the subnet e.g. `10.0.10.0/24` |
| `avail_zone` | string | Availability zone e.g. `ca-central-1a` |
| `env_prefix` | string | Environment prefix e.g. `dev`, `prod` |
| `my_ip` | string | Your public IP with /32 e.g. `1.2.3.4/32` |
| `instance_type` | string | EC2 instance type e.g. `t3.micro` |
| `public_key_location` | string | Local path to your `.pub` SSH key |
| `private_key_location` | string | Local path to your private SSH key |
| `image_name` | string | AMI name filter e.g. `al2023-ami-2023.*-x86_64` |

---

## terraform.tfvars Example

```hcl
vpc_cidr_block       = "10.0.0.0/16"
subnet_cidr_block    = "10.0.10.0/24"
avail_zone           = "ca-central-1a"
env_prefix           = "dev"
my_ip                = "YOUR_PUBLIC_IP/32"
instance_type        = "t3.micro"
public_key_location  = "/Users/you/.ssh/testing-v2.pub"
private_key_location = "/Users/you/.ssh/testing-v2"
image_name           = "al2023-ami-2023.*-x86_64"
```

> Get your public IP: `curl ifconfig.me`

---

## Usage

**1. Initialise:**
```bash
terraform init
```

**2. Preview:**
```bash
terraform plan -var-file="terraform.tfvars"
```

**3. Apply:**
```bash
terraform apply -var-file="terraform.tfvars"
```

**4. SSH into EC2:**
```bash
ssh -i ~/.ssh/testing-v2 ec2-user@<EC2_PUBLIC_IP>
```

**5. Open in browser:**
```
http://<EC2_PUBLIC_IP>:8080
```

**6. Destroy:**
```bash
terraform destroy -var-file="terraform.tfvars"
```

---

## Outputs

| Output | Description |
|---|---|
| `ec2_public_ip` | Public IP of the EC2 instance |
| `aws_ami_id` | AMI ID used for the EC2 instance |

---

## Security Notes

- Never commit `terraform.tfvars` — it contains your IP and key paths
- Never commit `.terraform/` — it contains large provider binaries (700MB+)
- Never commit `terraform.tfstate` — it contains sensitive resource details
- SSH is restricted to your IP only
- Always run `terraform plan` before `terraform apply`
