# Nutanix Kubernetes Bare-Metal Lab

A fully automated, production-inspired Kubernetes lab built on a physical Nutanix cluster — documenting the complete journey from bare-metal hardware to a monitored, hybrid-cloud Platform Engineering pipeline.

---

## About This Repository

This repository contains the complete Infrastructure as Code automation for my personal Homelab, built on a 4-node Intel Purley bare-metal cluster running the Nutanix Cloud Platform.

The goal is not just to study for certifications — it is to build a **Portfolio of Evidence** that demonstrates the ability to design, deploy, automate, and monitor an entire data center stack from hardware to container.

Every phase is documented as a reproducible guide, from provisioning VMs with Terraform to bootstrapping a production-grade Kubernetes cluster with kubeadm.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Hardware | 4x Intel Bare-Metal Nodes (Purley Platform) |
| Virtualization | Nutanix Cloud Platform (AHV) |
| Infrastructure as Code | Terraform |
| Configuration Management | Ansible |
| Container Orchestration | Kubernetes (kubeadm) |
| Monitoring | Prometheus & Grafana |
| Cloud Integration | AWS (S3, hybrid backup) |


---

## Repository Structure

```
nutanix-k8s-baremetal/
├── ansible/
│   └── inventory.yaml
├── architecture/
│   ├── software-matrix.md
│   └── topology.md
├── terraform/
│   └── providers.tf
├── tailored project guides/
│   └── Phase 3 - Kubeadm installation.md
└── README.md
```

---

## Lab Phases

| Phase | Guide | Status |
|---|---|---|
| Phase 0 | Ubuntu Management VM Setup | ✅ Complete |
| Phase 1 | Terraform VM Provisioning | ✅ Complete |
| Phase 2 | Ansible Configuration Management | ✅ Complete |
| Phase 3 | Kubeadm Cluster Bootstrap | ✅ Complete |
| Phase 4 | Observability - Prometheus & Grafana | 🔄 In Progress |
| Phase 5 | Cloud Jump - AWS Hybrid Integration | ⏳ Planned |

---

## Target Certifications

| Certification | Provider | Status |
|---|---|---|
| CKA - Certified Kubernetes Administrator | CNCF | 🔄 In Progress |
| AWS SAA - Solutions Architect Associate | Amazon | ⏳ Planned |

---

## Background

- **Experience:** 8 Years Platform Validation & Integration
- **Specialty:** Hybrid Platform Engineering (On-Prem + Cloud)
- **Focus:** Nutanix · Terraform · Ansible · Kubernetes · AWS

---

## Security Notice

> Security-sensitive configuration files (credentials, keys, secrets) are excluded from this repository via `.gitignore`.

---

## License

This project is for educational and portfolio purposes.

---

*Last Updated: June 2026*
