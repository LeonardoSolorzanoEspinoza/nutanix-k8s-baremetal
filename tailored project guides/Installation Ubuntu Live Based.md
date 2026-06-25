# Phase 0: Ubuntu Management VM Setup

**Goal:** Prepare a fully configured Ubuntu-based management workstation to serve as the control point for all Terraform, Ansible, and Kubernetes operations against the Nutanix cluster.

---

## Overview

| Detail | Info |
|---|---|
| Phase | 0 - Pre-requisite Setup |
| OS | Ubuntu 22.04+ |
| Last Updated | June 22, 2026 |
| Next Phase | Phase 1 - Terraform Provisioning |

---

## Step 1: Update OS and Install Base Utilities

Ensure the management OS is fully patched and has the basic networking and archive tools needed for later phases.

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl unzip git software-properties-common dnsutils jq
```

>  **Minimal Installation Note:** If SSH refuses to connect after setup:

```bash
sudo apt update
sudo apt install openssh-server -y
sudo systemctl enable --now ssh
```

---

## Step 2: Generate SSH Key Pair

Terraform will inject a public SSH key into your future Kubernetes VMs for later configuration via Ansible, cloud-init, or direct SSH.

### 2.1 Generate ED25519 Key Pair

Log into your management VM via PuTTY and run:

```bash
ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_ed25519
```

| Flag | Description |
|---|---|
| `-t ed25519` | High-performance, short-key cryptography standard |
| `-N ""` | Empty passphrase for automated script compatibility |
| `-f ~/.ssh/id_ed25519` | Saves to default SSH location |

### 2.2 Extract Your Public Key

```bash
cat ~/.ssh/id_ed25519.pub
```

Expected output format:

```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKg5... kubeadmin@k8s-mgmt-01
```

> Copy this entire line — you will need it for your Terraform `main.tf` configuration in Phase 1.

---

## Step 3: Terraform VM Blueprint

> Preview — Go to `/terraform`

---

## Step 4: Configure Passwordless Sudo

>  Required so automated scripts can run without interactive password prompts.

### 4.1 Open Sudoers File

> Always use `visudo` — it validates syntax before saving, preventing accidental lockouts.

```bash
sudo visudo
```

### 4.2 Locate and Modify the Sudo Group Line

Find this line:

```
%sudo ALL=(ALL:ALL) ALL
```

Change it to:

```
%sudo ALL=(ALL:ALL) NOPASSWD:ALL
```

### 4.3 Save and Exit

| Editor | Save Command | Exit Command |
|---|---|---|
| Nano (default) | `Ctrl+O` then `Enter` | `Ctrl+X` |
| Vim | `:wq + Enter` | (included in `:wq`) |

### 4.4 Validate the Change

```bash
# Clear cached sudo timestamp
sudo -k

# Test passwordless sudo
sudo apt update
```

✅ Success: Command executes immediately without a password prompt.

---

##  Phase 0 Completion Checklist

- [x] OS updated and base utilities installed
- [x] SSH server running and accessible
- [x] ED25519 key pair generated
- [x] Public key copied and saved for Terraform use
- [x] Passwordless sudo configured and validated
- [x] Ready to proceed to Phase 1

---

## 🔗 Next Steps

| Phase | Guide | Description |
|---|---|---|
| Phase 1 | phase-1-terraform in detail.md | Deploy K8s VMs via Terraform |
| Phase 2 | phase-2-ansible.md | Configure VMs via Ansible |

---

*Last Updated: June 2026*