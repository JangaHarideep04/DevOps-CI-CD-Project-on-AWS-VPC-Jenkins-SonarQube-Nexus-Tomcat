# 📡 AWS VPC Architecture - CI/CD DevOps Project

This document provides a visual and structured overview of the VPC networking setup used in our end-to-end DevOps project.

---


![ChatGPT Image Jul 7, 2025, 07_12_04 PM](https://github.com/user-attachments/assets/4424b1dc-b877-468d-92ac-f4eb177c4663)


---

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

## Vpc:
![Vpc](https://github.com/user-attachments/assets/297106f4-fd14-4bb6-a992-af8af26ea994)

---

## Subnets:
![subnets](https://github.com/user-attachments/assets/c6051ea2-f914-4b17-891f-32840bd34f22)

---

## Route Tables:
![route-tables](https://github.com/user-attachments/assets/3b524f66-098c-4246-9b00-9862789d6c99)

---

## Internet-Gateway:
![Internet-gateway](https://github.com/user-attachments/assets/0ccdf6d5-b040-4f8e-a5bc-fdbbd4fa6d11)

---

## NAT Gateway:
![Nat-gateway](https://github.com/user-attachments/assets/e251e75f-300d-49a6-82bb-a5c07d4c5a74)

---

## Target-Groups:
![Target-Groups](https://github.com/user-attachments/assets/9e7981e3-652c-4578-b130-3318bd63a15e)

---

## Load-Balancer:
![Load-Balancer](https://github.com/user-attachments/assets/defcf77c-b89e-4f4b-abae-37e3c9906240)

---

## Security-groups:

![SG's](https://github.com/user-attachments/assets/ed3ae38c-83f7-4a96-8891-84fd67a9924b)
