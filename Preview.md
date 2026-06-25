Golden Plan: CKA Certification & Platform Engineering Path
Mission: Transform a physical Nutanix cluster into a professional-grade Platform Engineering pipeline — building a Portfolio of Evidence that proves you can automate an entire data center.

📋 Overview
Detail	Info
Created	April 3, 2026
Target	CKA Certification + Platform Engineering Portfolio
Infrastructure	Nutanix On-Prem (WOLF2224SATA-NVME Cluster)
Timeline	6-12 Months

🗺️ Roadmap Summary
MERMAID
graph LR
    A --> X[Phase 1\nInfrastructure as Code] --> B[Phase 2\nConfiguration Management]
    B --> C[Phase 3\nCKA Lab]
    C --> D[Phase 4\nObservability]
    D --> E[Phase 5\nCloud Jump]

Phase 1: Infrastructure as Code 🏗️
Goal: Stop using the Prism UI. Manage Intel nodes via code.
Steps
 Workstation Setup
Install Terraform on local machine or dedicated Management VM
 Nutanix Provider Configuration
Configure the nutanix provider in Terraform
Connect to Prism Element/Central
 Write Terraform Blueprint .tf
HCL
# VM Specifications
# Control Plane: 1x VM (Ubuntu 22.04+, 2 vCPUs, 4GB RAM)
# Worker Nodes:  3x VM (Ubuntu 22.04+, 2 vCPUs, 4GB RAM)
 Execute Deployment
BASH
terraform apply
✅ Validation Checkpoint
If 4 VMs appear in Prism without clicking "Create VM" — you have officially moved into the modern infrastructure era.
Phase 2: Configuration Management 🔧
Goal: Treat VMs like "cattle, not pets." No individual SSH installs.
Steps
 Install Ansible on Management VM
 Create Inventory File
INI
# inventory.ini
[master_node]
<control-plane-ip>

[workers]
<worker-node-1-ip>
<worker-node-2-ip>
<worker-node-3-ip>
 Write Kubeadm Ansible Playbook setup-k8s.yml
Disable Swap (required for K8s)
Install Container Runtime (Containerd)
Install kubeadm, kubelet, kubectl
 Run Playbook
BASH
ansible-playbook setup-k8s.yml
✅ Validation Checkpoint
All nodes are ready for cluster initialization.
Phase 3: CKA Lab 🎓
Goal: Build the cluster manually to master the CKA curriculum.
Steps
 Initialize Cluster
BASH
kubeadm init
 Install CNI Plugin
Options: Calico or Cilium
💡 Expert Tip: With 10 years in validation, understand why pods can't communicate before the CNI is installed.
 Join Worker Nodes
BASH
kubeadm join <control-plane-ip>:6443 --token <token>
 CKA Practice Drills
 Back up etcd
 Upgrade cluster from v1.31 → v1.32
 Fix broken Static Pods
 Practice on Killer.sh simulators
✅ Validation Checkpoint
Complete Killer.sh simulator with passing score.
Phase 4: Observability 📊
Goal: Leverage 10 years of experience — the job isn't done until the system is monitored.
Steps
 Install Helm
BASH
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
 Deploy Monitoring Stack
BASH
helm install prometheus prometheus-community/kube-prometheus-stack
helm install grafana grafana/grafana
 Build Grafana Dashboard
CPU/RAM usage: Nutanix VMs vs K8s Pods
Node health metrics
Cluster resource utilization
✅ Validation Checkpoint
Dashboard shows full-stack visibility from hardware to container.
💼 Career Value: Proves understanding of the full stack — from bare metal to container.
Phase 5: Cloud Jump ☁️
Goal: Connect the bare-metal world to AWS.
Steps
 AWS Solutions Architect Associate (SAA)
Study and pass AWS SAA certification
 Build Hybrid Project
HCL
# Terraform: Create S3 Bucket in AWS
resource "aws_s3_bucket" "etcd_backup" {
  bucket = "nutanix-k8s-etcd-backup"
}
 Configure K8s CronJob
Automate etcd backups to AWS S3
✅ Validation Checkpoint
etcd backups are automatically stored in AWS S3.
🎯 The Pitch: "I manage a hybrid cloud where on-premise Kubernetes backups are automated to AWS S3 using Terraform and K8s CronJobs."
💼 2026 Target Profile
Category	Details
Background	10 Years Platform Validation & Integration
Specialty	Hybrid Platform Engineering (On-Prem + Cloud)
Toolbox	Nutanix · Terraform · Ansible · Kubernetes (CKA) · AWS (SAA)
Target Salary (GDL)	$110k - $140k MXN Gross/Month
Target Salary (US Remote)	$7k - $9k USD/Month
⚠️ Realistic Concerns & Adjustments
Timeline Expectations
This is a 6-12 month journey, not a quick sprint
Phase 3 (CKA) alone typically requires 2-3 months of focused study
Resource Requirements
Nutanix cluster: 16GB+ RAM recommended
CKA Exam: $395 USD
AWS Costs: Minimal for learning purposes
Suggested Modifications
Start Smaller: 1 Control Plane + 2 Workers initially
Add GitOps: Consider ArgoCD or Flux in Phase 4
Documentation: Maintain this GitHub repo as a learning journal
📦 Tech Stack
Nutanix Terraform Ansible Kubernetes AWS Prometheus Grafana
Last Updated: June 2026