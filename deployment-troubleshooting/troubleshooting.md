## Cluster Deployment Troubleshooting & Resolution

This note captures the main issues encountered during cluster creation and the engineering steps used to resolve them.

---

### 1. Storage volume exhaustion during `kubeadm init`

**Symptom:** The `kubeadm init` sequence on the control plane failed with `No space left on device`.

**Root cause:** The initial storage allocation was too small to hold the base OS, `containerd`, control plane images, and operational logs.

**Resolution:**
1. Tore down the failed deployment with `terraform destroy`.
2. Updated the Terraform configuration to add **60 GiB of block storage** to each of the four cluster VMs.
3. Re-provisioned the infrastructure.

---

### 2. Inter-node SSH authentication

**Symptom:** SSH automation failed when the control plane attempted to reach the worker nodes, returning `Permission denied (publickey)`.

**Root cause:** The control plane did not have an SSH key that matched the worker nodes' `authorized_keys` configuration, which broke automated node-to-node management.

**Resolution:**
Implemented an SSH trust bootstrap flow using the management workstation (`k8s-mgmt-01`) and Ansible.

**Step 1: Generate the SSH key pair**

Create a high-entropy Ed25519 key pair on the management workstation without a passphrase:

```bash
ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_ed25519
```

**Step 2: Inject the public key**

Copy the public key and distribute it to the cluster nodes:

```bash
ansible all -i inventory.ini -m authorized_key -a "user=ubuntu state=present key='PASTE_YOUR_COPIED_KEY_HERE'"
```

*Last Updated: June 2026*