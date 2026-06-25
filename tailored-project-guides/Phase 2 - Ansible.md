# Phase 2: Ansible Configuration Management

**Goal:** Treat your VMs like "cattle, not pets." Configure all Kubernetes prerequisites across all nodes simultaneously — no individual SSH installs.

---

## Overview

| Detail | Info |
|---|---|
| Phase | 2 - Configuration Management |
| Tool | Ansible |
| Last Updated | June 2026 |
| Depends On | Phase 1 - Terraform Provisioning |
| Next Phase | Phase 3 - kubeadm installation |

---

## Step 1: Install Ansible on Management VM

Log into `k8s-mgmt-01` and run:

```bash
sudo apt update
sudo apt install software-properties-common -y
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y
```

### Verify Installation

```bash
ansible --version
```

---

## Step 2: Set Up Project Directory

> Keep Ansible files separate from your Terraform state for a clean workspace.

```bash
# Create Ansible project directory
mkdir -p ~/k8s-nutanix/ansible

# Navigate to directory
cd ~/k8s-nutanix/ansible
```

**Expected Directory Structure:**

```
k8s-nutanix/
└── ansible/
  ├── ansible.cfg        # Ansible configuration
  ├── inventory.ini      # Node IP assignments
  └── k8s-prep.yaml      # K8s prerequisites playbook
```

---

## Step 3: Create the Ansible Inventory File

```bash
nano inventory.ini
```

Paste the following, replacing `<IP_ADDRESS>` placeholders with your actual VM IPs from Terraform output:

```ini
[master_node]
controlplane ansible_host=<IP_ADDRESS_OF_CONTROLPLANE>

[workers]
node01 ansible_host=<IP_ADDRESS_OF_NODE01>
node02 ansible_host=<IP_ADDRESS_OF_NODE02>
node03 ansible_host=<IP_ADDRESS_OF_NODE03>

[k8s_cluster:children]
master_node
workers

[k8s_cluster:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/id_ed25519
```

> Why this format? By defining hostnames (`controlplane`, `node01`, etc.) on the left side of `ansible_host`, Ansible automatically uses these labels internally during playbook runs.
## Step 4: Disable Strict Host Key Checking

> **Lab Pro-Tip:** New VMs will trigger SSH's "Are you sure you want to continue connecting?" prompt. Ansible will freeze if it hits this. Bypass it safely for your trusted lab environment.

```bash
nano ansible.cfg
```

Add these lines:

```ini
[defaults]
inventory = inventory.ini
host_key_checking = False
```

---

## Step 5: Test the Connection

Before writing any playbooks, verify Ansible can reach all four nodes and elevate to root via passwordless sudo (configured via Cloud-Init in Phase 1).

```bash
ansible k8s_cluster -m ping -b
```

Expected Result: Green `pong` response from all 4 nodes. The `-b` flag means "become root" (sudo escalation).

---

## Step 6: Create the Kubernetes Prep Playbook

> Go to `/ansible` — this playbook executes all prerequisites required for kubeadm and containerd to function correctly.

---

## Step 7: Run the Kubernetes Prep Playbook

```bash
ansible-playbook k8s-prep.yaml
```

**Success Criteria:** Terminal returns with recap showing `failed=0` on all nodes.

All nodes are now staged and ready for:
- Container runtime installation (containerd)
- Kubernetes binaries (kubeadm, kubelet, kubectl)

---

## Step 8: DNS Pre-Solution (Fix /etc/hosts)

> Before initializing the cluster, ensure all nodes can resolve each other by short hostname. This prevents kubeadm join failures.

### 8.1 - Create the Hosts File Playbook

> Go to `/ansible`

> Verify the IP addresses match your `inventory.ini` before running.

### 8.2 - Run the Playbook

```bash
ansible-playbook -i inventory.ini fix-hosts.yaml
```

---

## Step 9: Configure SSH Between Nodes

> Required so kubeadm can communicate between the control plane and worker nodes during cluster initialization.

### 9.1 - Generate SSH Key on Control Plane

SSH into your control plane node and run:

```bash
ssh-keygen -t ed25519
```

Press `Enter` through all prompts to leave the passphrase blank.

### 9.2 - View and Copy the Public Key

```bash
cat ~/.ssh/id_ed25519.pub
```

Expected output format:

```
ssh-ed25519 <YOUR-CONTROLPLANE-PUBLIC-KEY> ubuntu@controlplane
```

> Copy the entire line — you will need it in the next step.

### 9.3 - Distribute Key to All Nodes via Ansible

Run this from your `k8s-mgmt-01` management VM, pasting the key you copied:

```bash
ansible all -i inventory.ini \
  -m authorized_key \
  -a "user=ubuntu state=present key='<PASTE-YOUR-CONTROLPLANE-PUBLIC-KEY-HERE>'"
```

Result: The control plane can now SSH into all worker nodes without a password prompt — required for kubeadm.

---

## 🔗 Next Steps

| Phase | Guide | Description |
|---|---|---|
| Phase 3 | phase-3-kubeadm installation.md | Build and practice K8s cluster |
| Phase 4 | phase-4-observability.md | Deploy Prometheus and Grafana |

---

*Last Updated: June 2026*