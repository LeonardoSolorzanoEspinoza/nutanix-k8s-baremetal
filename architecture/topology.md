# WOLF2224SATA-NVME Nutanix Cluster

## Cluster Overview
- **Cluster Name:** WOLF2224SATA-NVME
- **Target Type:** On Premises
- **Architecture:** Intel Purley Platform
- **Node Count:** 4 Nodes

## Network Configuration

### General Network Settings
| Parameter | Value |
|-----------|-------|
| Netmask | 255.255.255.128 |
| Gateway | 192.168.104.1 |
| Subnet | 192.168.104.0/25 |

### Node IP Assignments
| Node | Hypervisor IP | CVM IP | IPMI IP | Virtual IP |
|------|---------------|--------|---------|------------|
| WLP2224N01 | 192.168.104.31 | 192.168.104.34 | 192.168.104.27 | 192.168.104.38 |
| WLP2224N02 | 192.168.104.32 | 192.168.104.35 | 192.168.104.25 | 192.168.104.39 |
| WLP2224N03 | 192.168.104.30 | 192.168.104.33 | 192.168.104.23 | 192.168.104.37 |
| WLP2224N04 | 192.168.104.41 | 192.168.104.42 | 192.168.104.26 | 192.168.104.40 |

## Hardware Specifications

### Server Platform
- **Chassis Model:** Intel R2224WFTZSR
- **System:** Intel Corporation S2600WF0
- **BIOS:** SE5C620.86B.02.01.0017.CNX15.110620230543
- **BMC Version:** 2.88.67

### CPU Configuration
| Node | Processor Model | Base Frequency | Cores |
|------|----------------|----------------|-------|
| WLP2224N01 | Intel Xeon Gold 5220R | 2.20GHz | Dual Socket |
| WLP2224N02 | Intel Xeon Gold 6230 | 2.10GHz | Dual Socket |
| WLP2224N03 | Intel Xeon Gold 6230 | 2.10GHz | Dual Socket |
| WLP2224N04 | Intel Xeon Platinum 8260L | 2.40GHz | Dual Socket |

### Memory Configuration
| Node | Memory Type | Capacity per DIMM | Total Memory |
|------|-------------|-------------------|--------------|
| WLP2224N01 | 36ASF2G72PZ-2G6B2/E1 | 16GB | ~96GB |
| WLP2224N02 | 36ASF4G72PZ-2G6D1 | 32GB | ~96GB |
| WLP2224N03 | 18ASF2G72PDZ-2G6D1/H1R | 16GB | ~96GB |
| WLP2224N04 | Multiple Types | 16GB | ~96GB |

### Storage Configuration

#### NVMe Storage
- **Model:** Intel SSDPE2KE016T8
- **Capacity:** 1.6TB per drive
- **Firmware:** VDV10194
- **Nodes:** All 4 nodes

#### SATA SSD Storage
| Model | Capacity | Firmware | Nodes |
|-------|----------|----------|-------|
| Intel SSDSC2KB019T8 | 1.92TB | XCV10165/151/140 | All nodes |
| Intel SSDSC2KB038T8 | 3.84TB | XCV10151 | WLP2224N02, N03 |
| Intel SSDSCKKB480G8 | 480GB | XC311151 | WLP2224N01 |
| Intel SSDSCKKB240G8 | 240GB | XC311151 | WLP2224N02, N03, N04 |

### Network Interface Cards
| Model | Speed | Firmware | Nodes |
|-------|-------|----------|-------|
| Intel X710 10GbE SFP+ | 10Gbps | 9.55 | WLP2224N01, N02, N03 |
| Mellanox ConnectX-4 Lx | 10Gbps | 14.23.1020 | WLP2224N04 |

### Storage Controllers
- **Broadcom LSI SAS3416** - Tri-Mode I/O Controller (Firmware: 24.00.04.00)
- **Broadcom LSI SAS3516** - Tri-Mode RAID Controller (Firmware: 24.00.04.00)
- **Intel C620 Series SATA Controllers** - AHCI Mode

### Power Supply
| Model | Capacity | Nodes |
|-------|----------|-------|
| H79286-010 | 32.7kW | WLP2224N01 |
| H79286-008 | 32.7kW | WLP2224N02, N03 |
| H79286-007/006 | 32.7kW | WLP2224N04 |

## Firmware Status
- NVMe drives require firmware updates
- SATA SSDs require qualification
- Network cards need status verification

## Management Access
- **IPMI Username:** root
- **IPMI Password:** [Configured]
- **Hypervisor Access:** [Configured]

---
*Last Updated: June 2026*
