# 📡 AWS VPC Architecture - CI/CD DevOps Project

This document provides a visual and structured overview of the VPC networking setup used in our end-to-end DevOps project.

---

## 📘 VPC Overview

| Property               | Value                               |
|------------------------|-------------------------------------|
| **VPC CIDR**           | `192.168.0.0/22`                    |
| **Public Subnets**     | `192.168.0.0/24`, `192.168.1.0/24`  |
| **Private Subnets**    | `192.168.2.0/24`, `192.168.3.0/25`  |
| **Reserved Subnets**   | `192.168.3.128/26`, `192.168.3.192/26` |

---

## 🌐 Subnet Distribution

### 🔓 Public Subnets
Used for hosting:
- **Load Balancer (ALB)**
- **NAT Gateway**
- **Bastion Host (if applicable)**

### 🔐 Private Subnets
Used for hosting:
- **Jenkins** (`192.168.2.0/24`)
- **SonarQube** (`192.168.2.0/24` or `192.168.3.0/25`)
- **Nexus Repository** (`192.168.3.0/25`)
- **Tomcat Server** (`192.168.3.0/25`)

---

## 🔀 Routing and Gateways

### 🌍 Internet Gateway
- Attached to the VPC
- Associated with public subnet route table to allow inbound/outbound internet access

### 🚪 NAT Gateway
- Placed in public subnet (e.g., `192.168.0.0/24`)
- Allows private subnet EC2 instances to access the internet (e.g., to download packages)

### 🗺️ Route Tables

| Route Table         | Associated Subnets                   | Notable Routes                  |
|---------------------|--------------------------------------|---------------------------------|
| **Public RT**       | `192.168.0.0/24`, `192.168.1.0/24`   | `0.0.0.0/0` → Internet Gateway  |
| **Private RT**      | `192.168.2.0/24`, `192.168.3.0/25`   | `0.0.0.0/0` → NAT Gateway       |

---

## 🎯 Target Groups

| Target Group Name | Port  | Purpose                      |
|-------------------|-------|------------------------------|
| `jenkins-tg`      | 8080  | Jenkins CI interface         |
| `tomcat-tg`       | 8081  | Web app deployment endpoint  |
| `sonarqube-tg`    | 9000  | Code analysis UI             |
| `nexus-tg`        | 8082  | Artifact repository access   |

---

## ⚖️ Application Load Balancer (ALB)

- Created in **Public Subnets**
- Listener ports configured:
  - `8080` → Jenkins
  - `8081` → Tomcat
  - `8082` → Nexus
  - `9000` → SonarQube
- Registered all private EC2s under appropriate target groups

---

## 📷 Visual Snapshots (To Be Uploaded)

Place your screenshots in `/assets/` folder:

- [ ] VPC Overview
- [ ] Subnets
- [ ] Route Tables
- [ ] Internet Gateway
- [ ] NAT Gateway
- [ ] Target Groups
- [ ] Load Balancer Configuration

Embed them like:

```md
![VPC Diagram](./assets/vpc-overview.png)
