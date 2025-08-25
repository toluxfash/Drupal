Drupal Deployment with Terraform & Ansible
📌 Overview
This project provisions a highly available Drupal environment on AWS using Terraform and configures the application with Ansible.
It sets up:
A custom VPC with two public subnets across availability zones.
Two EC2 web servers running Drupal behind an Application Load Balancer (ALB).
An RDS MySQL database for Drupal’s backend.
Ansible automation to install and configure Drupal with Apache and PHP.

📂 Project Structure
```bash
Drupal/
├── ansible
│   ├── install_drupal.yml       # Ansible playbook for Drupal installation
│   ├── inventory
│   │   └── hosts.ini            # Inventory with webserver IPs and SSH config
│   └── templates
│       └── drupal.conf.j2       # Apache VirtualHost template for Drupal
└── terraform
    ├── main.tf                  # AWS resources (VPC, EC2, ALB, RDS, etc.)
    ├── provider.tf              # AWS provider configuration
    └── variable.tf              # Input variables for Terraform

```
⚙️ Prerequisites

Terraform >= v1.3
Ansible >= v2.12
An AWS account with programmatic access (Access Key & Secret Key).
An existing AWS key pair (update in variable.tf and hosts.ini).
SSH access to the created EC2 instances.

Deployment Steps
1️⃣ Infrastructure with Terraform

Navigate to the terraform/ directory:
1. Navigate to the terraform/ directory:
   ```bash
   cd terraform

2. Initialize Terraform:
   ```bash
   terraform init

3. Review the execution plan:
    ```bash
    terraform plan
4. Apply the configuration:
    ```bash
    terraform apply
5. After completion, Terraform outputs the ALB DNS name:
    ```bash
    loadbalancedns = myalb-xxxxxxx.us-east-1.elb.amazonaws.com

2️⃣ Configure Servers with Ansible

1. Update your Ansible inventory/hosts.ini file with the public IPs of the EC2 instances.
    ```bash
    [webservers]
<EC2_PUBLIC_IP_1>
<EC2_PUBLIC_IP_2>

[webservers:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/toluxfash.pem
ansible_ssh_common_args='-o StrictHostKeyChecking=no'

2.  Run the Ansible playbook:
cd ../ansible
    ```bash
    ansible-playbook -i inventory/hosts.ini install_drupal.yml

3. This will:
-Install Apache, PHP, and required modules.
-Download and configure the latest Drupal release.
-Configure an Apache VirtualHost with rewrite rules.
-Restart Apache to serve Drupal.

Accessing Drupal

Open your browser and visit the ALB DNS name from Terraform output:
http://<loadbalancedns>

Complete the Drupal web-based installation wizard:
Database Host: Internal RDS endpoint
Database Name: drupal_db (default from variable.tf)
Database User: admin
Database Password: securepassword123

🔧 Customization
Change DB credentials → in terraform/variable.tf.
Update Apache config → in ansible/templates/drupal.conf.j2.
Add more web servers → extend aws_instance resources in Terraform.
Scaling → attach Auto Scaling Groups instead of fixed EC2 instances.

🗑️ Cleanup
To destroy all AWS resources:
    ```bash
cd terraform
terraform destroy -auto-approve

📖 Notes
Ensure your SSH private key (.pem) is available locally and its path is correct in hosts.ini.
The RDS instance is not publicly accessible, only webservers can connect to it for security.
Drupal version is always the latest stable release (downloaded during Ansible run).

✅ With this setup, you get a production-ready Drupal deployment on AWS managed with Infrastructure-as-Code (Terraform) and Configuration Management (Ansible).
