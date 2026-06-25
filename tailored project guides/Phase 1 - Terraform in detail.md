Phase 1: Terraform Provisioning 🏗️

Goal: Stop using the Prism UI. Deploy and manage Kubernetes VMs on your Nutanix cluster using Infrastructure as Code.

📋 Overview
Detail	Info
Phase	1 - Infrastructure as Code
Tool	Terraform by HashiCorp
Last Updated	June 2026
Depends On	Phase 0 - Ubuntu Management VM Setup
Next Phase	Phase 2 - Ansible Configuration

Part 1: Installing Terraform
Step 1.1 - Update and Install Dependencies
BASH
sudo apt update && sudo apt install -y gnupg software-properties-common curl
Package	Purpose
gnupg	Verifies authenticity of downloaded packages
software-properties-common	Manages independent software repositories
curl	Downloads files from the internet
Step 1.2 - Download and De-armor the GPG Key
BASH
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
💡 Why? Linux needs to trust the source of the code before installing it.
Flag	Purpose
--dearmor	Converts key from ASCII text to binary format
/usr/share/keyrings/	Isolated, secure storage location for the key
Step 1.3 - Add HashiCorp Repository
BASH
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list
💡 Why? By default, Ubuntu only knows about its own software. This tells your system to also check HashiCorp's servers for Terraform.
📋 Note: $(lsb_release -cs) automatically detects your Ubuntu version (e.g., noble) so you don't have to type it manually.
Step 1.4 - Install Terraform
BASH
sudo apt update && sudo apt install terraform -y
⚠️ Important: You must run apt update again so Ubuntu can see the new packages available in the HashiCorp repository.
Step 1.5 - Verify Installation
BASH
terraform --version

Part 2: Key Notes for Nutanix Environment
2.1 - Verify Prism Connectivity
Your management VM must be able to communicate with Prism Element or Prism Central over port 9440. Test with:
BASH
# Basic connectivity test
curl -k https://<YOUR-PRISM-IP>:9440

# Full API test
curl -k -u "admin:<YOUR-PASSWORD>" \
  -X POST https://<YOUR-PRISM-IP>:9440/api/nutanix/v3/clusters/list \
  -H "Content-Type: application/json" \
  -d '{}' | jq
2.2 - Terraform State File
⚠️ Critical: Terraform keeps a state file terraform.tfstate that remembers everything it built.
Rule	Reason
Never delete terraform.tfstate	Terraform will lose track of your VMs and try to rebuild them
Never commit terraform.tfstate to GitHub	It may contain sensitive infrastructure data
Add to .gitignore	*.tfstate and *.tfstate.backup
Recommended .gitignore entries:
# Terraform *.tfstate *.tfstate.backup .terraform/ .terraform.lock.hcl terraform.tfvars
2.3 - Environment Variables (Security Best Practice)
🔒 Never hardcode credentials in your Terraform files. Set them as environment variables in your terminal session:
BASH
export NUTANIX_USERNAME='admin'
export NUTANIX_PASSWORD='<YOUR-PASSWORD>'
export NUTANIX_ENDPOINT='<YOUR-PRISM-IP>'

Part 3: Gathering Nutanix Identifiers
💡 Terraform uses UUIDs internally, not friendly names like "Default-Network" or "Ubuntu-Image". You need to retrieve these from your Prism console before writing your Terraform files.
Required UUIDs
UUID	Description
cluster_uuid	ID of your Nutanix hardware cluster
subnet_uuid	ID of the network/VLAN for your VMs
image_uuid	ID of the Ubuntu 24.04 cloud image
3.1 - Recommended Image
ubuntu-24.04-server-cloudimg-amd64.img
💡 Use the Generic Cloud Image for a clean, functional cluster that mirrors standard learning environments.
3.2 - Retrieve Image UUID
BASH
# Note: Use -u 'admin:password' to avoid password appearing in logs
curl -k -u 'admin:<YOUR-PASSWORD>' \
  -X POST https://<YOUR-PRISM-CVM-IP>:9440/api/nutanix/v3/images/list \
  -H "Content-Type: application/json" \
  -d '{"kind": "image"}' | jq
📋 How to read the output: Look for your Ubuntu 24.04 image name and grab the uuid string next to it. Example format: 550e8400-e29b-41d4-a716-446655440000
3.3 - Retrieve Cluster UUID
BASH
curl -k -u 'admin:<YOUR-PASSWORD>' \
  -X POST https://<YOUR-PRISM-CVM-IP>:9440/api/nutanix/v3/clusters/list \
  -H "Content-Type: application/json" \
  -d '{"kind": "cluster"}' | jq
3.4 - Retrieve Subnet UUID
BASH
curl -k -u 'admin:<YOUR-PASSWORD>' \
  -X POST https://<YOUR-PRISM-CVM-IP>:9440/api/nutanix/v3/subnets/list \
  -H "Content-Type: application/json" \
  -d '{"kind": "subnet"}' | jq

Part 4: Creating Configuration Files
4.1 - Create Project Directory Structure
BASH
# Create project directory
mkdir -p ~/nutanix-projects/k8s-cluster

# Navigate to directory
cd ~/nutanix-projects/k8s-cluster

# Create configuration files
touch main.tf providers.tf variables.tf
Expected Directory Structure
k8s-cluster/ ^ main.tf # VM resource definitions ^ providers.tf # Nutanix provider configuration ^ variables.tf # Input variables.

Part 5: Execution
5.1 - Run Terraform Commands in Order
BASH
# Step 1: Download the Nutanix provider plugin
terraform init

# Step 2: Preview the 4 VMs it will create - review carefully!
terraform plan

# Step 3: Create the VMs on your Nutanix cluster
terraform apply
⚠️ Review the terraform plan output carefully before typing yes on terraform apply.

Part 6: Tear Down and Rebuild
💡 Cloud-Init scripts only execute on the first boot of a virtual disk. If you modify cloud-init config, you must destroy and recreate the VMs.
6.1 - Destroy Existing VMs
BASH
terraform destroy
Review the plan (should show 4 resources to destroy) and type yes.
6.2 - Clean Terraform State
BASH
rm -rf .terraform* terraform.lock.hcl terraform.tfstate*
6.3 - Rebuild VMs
BASH
terraform apply
Part 7: Accessing Your Cluster Nodes
Once Terraform completes, Nutanix will:
Power on the VMs
Read the Base64 cloud-init script
Create the ubuntu user account
Inject your SSH public key
Configure passwordless sudo
Connect to Your Nodes
BASH
# Connect to Control Plane
ssh ubuntu@<CONTROLPLANE-IP>

# Connect to Worker Nodes
ssh ubuntu@<NODE01-IP>
ssh ubuntu@<NODE02-IP>
ssh ubuntu@<NODE03-IP>
✅ Phase 1 Completion Checklist
 Terraform installed and verified
 Prism connectivity confirmed
 All UUIDs retrieved (Cluster, Subnet, Image)
 variables.tf configured with your values
 providers.tf configured
 main.tf configured
 terraform init completed successfully
 terraform plan reviewed
 terraform apply completed - 4 VMs visible in Prism
 SSH access confirmed to all nodes
 Ready to proceed to Phase 2
🔗 Next Steps
Phase	Guide	Description
Phase 2	phase-2-ansible.md	Configure K8s on VMs via Ansible
Phase 3	phase-3-kubeadm installation.md	Build and practice K8s cluster
Last Updated: June 2026