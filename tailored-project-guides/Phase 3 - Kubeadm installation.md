# Phase 3: Kubeadm Installation & Cluster Bootstrap

**Goal:** Install Kubernetes binaries on all nodes and bootstrap the cluster manually to master the CKA curriculum.

---

## Overview

| Detail | Info |
|---|---|
| Phase | 3 - Cluster Bootstrap |
| Kubernetes Version | v1.35 |
| Last Updated | June 2026 |
| Depends On | Phase 2 - Ansible Configuration |
| Next Phase | Phase 4 - Observability |

---

## Part 1: Install Kubernetes Binaries

> Run these steps on **ALL nodes** (control plane + workers) unless otherwise specified.

### Step 1.1 - Update Package Index and Install Prerequisites

```bash
sudo apt-get update

# Note: apt-transport-https may be a dummy package
# on newer Ubuntu versions - safe to skip if not found
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
```

### Step 1.2 - Download Kubernetes Package Signing Key

```bash
# Create keyrings directory if it does not exist
# Required for Ubuntu versions older than 22.04
sudo mkdir -p -m 755 /etc/apt/keyrings

# Download and store the signing key
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.35/deb/Release.key | \
  sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
```

> **Older Systems Note:** On releases older than Debian 12 or Ubuntu 22.04, the `/etc/apt/keyrings` directory does not exist by default. Always run the `mkdir` command above to be safe.

### Step 1.3 - Add Kubernetes APT Repository

```bash
# This overwrites any existing configuration
# in /etc/apt/sources.list.d/kubernetes.list
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] \
https://pkgs.k8s.io/core:/stable:/v1.35/deb/ /' | \
sudo tee /etc/apt/sources.list.d/kubernetes.list
```

> **Version Note:** This repository contains packages only for Kubernetes v1.35. To install a different version, change the minor version number in the URL: `https://pkgs.k8s.io/core:/stable:/v1.XX/deb/`

### Step 1.4 - Install Kubernetes Binaries

```bash
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl

# Pin versions to prevent accidental upgrades
sudo apt-mark hold kubelet kubeadm kubectl
```

| Binary | Purpose |
|---|---|
| `kubelet` | Node agent - runs on every node |
| `kubeadm` | Cluster bootstrap tool |
| `kubectl` | CLI to interact with the cluster |

> Why pin versions? `apt-mark hold` prevents these packages from being upgraded during a routine `apt upgrade`, which could break your cluster unexpectedly.

### Step 1.5 - Enable Kubelet Service

```bash
sudo systemctl enable --now kubelet
```

> Note: The kubelet will enter a crash loop until `kubeadm init` is run. This is expected behavior.
---

## Part 2: Cluster Initialization (Control Plane Only)

> Run these steps on the **CONTROL PLANE** node only.

### Step 2.1 - Check Network Interface

```bash
ip route show
```

> Use this to identify your active network interface name (e.g., `eth0`, `ens3`, `enp3s0`) before running `kubeadm init`.

### Step 2.2 - Pod Network CIDR Golden Rules

Before initializing, choose your Pod network CIDR carefully:

| Rule | Description |
|---|---|
| ✅ Must be RFC 1918 | Use a private IP range |
| ✅ Must not overlap | Cannot conflict with your physical host network |
| ✅ Must match CNI | Should match your CNI provider's default |

**Recommended CIDR by CNI Provider:**

| CNI Provider | Recommended Pod CIDR | Service CIDR |
|---|---|---|
| Flannel | 10.244.0.0/16 | 10.96.0.0/16 |
| Calico | 192.168.0.0/16 | 10.96.0.0/16 |
| Cilium | 10.244.0.0/16 | 10.96.0.0/16 |

### Step 2.3 - Initialize the Cluster

```bash
# Auto-detect the control plane IP address
IP_ADDR=$(ip addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

# Initialize the cluster
kubeadm init \
  --apiserver-cert-extra-sans=controlplane \
  --apiserver-advertise-address $IP_ADDR \
  --pod-network-cidr=10.244.0.0/16 \
  --service-cidr=10.96.0.0/16
```

| Flag | Purpose |
|---|---|
| `--apiserver-cert-extra-sans` | Adds controlplane hostname to the API server certificate |
| `--apiserver-advertise-address` | IP address the API server will advertise |
| `--pod-network-cidr` | IP range for pod networking |
| `--service-cidr` | IP range for Kubernetes services |

---

## Part 3: Join Worker Nodes

### Step 3.1 - Generate Join Command (Control Plane)

```bash
kubeadm token create --print-join-command
```

Expected output format:

```
kubeadm join <CONTROLPLANE-IP>:6443 \
  --token <BOOTSTRAP-TOKEN> \
  --discovery-token-ca-cert-hash sha256:<CA-CERT-HASH>
```

> **Security Note:** This token expires after 24 hours. Generate a new one if needed.

### Step 3.2 - Join Worker Nodes

> Run on each **WORKER NODE** (node01, node02, node03). Copy the exact command output from Step 3.1.

```bash
kubeadm join <CONTROLPLANE-IP>:6443 \
  --token <YOUR-BOOTSTRAP-TOKEN> \
  --discovery-token-ca-cert-hash sha256:<YOUR-CA-CERT-HASH>
```

### Step 3.3 - Verify All Nodes Joined

Run on control plane:

```bash
kubectl get nodes
```

Expected Output:

```
NAME           STATUS   ROLES           AGE   VERSION
controlplane   Ready    control-plane   Xm    v1.35.x
node01         Ready    <none>          Xm    v1.35.x
node02         Ready    <none>          Xm    v1.35.x
node03         Ready    <none>          Xm    v1.35.x
```

---

## Phase 3 Completion Checklist

- [ ] Kubernetes binaries installed on all nodes
- [x] Versions pinned with `apt-mark hold`
- [x] `kubeadm init` completed on control plane
- [ ] Worker nodes joined successfully
- [x] All nodes show `Ready` status

---

## 🔗 Next Steps

| Phase | Guide | Description |
|---|---|---|
| Phase 4 | phase-4-observability.md | Deploy Prometheus and Grafana |
| Phase 5 | phase-5-cloud-jump.md | Connect to AWS |

---

*Last Updated: June 2026*