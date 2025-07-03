# 🚀 DevOps CI/CD Project on AWS – VPC, Jenkins, SonarQube, Nexus, Tomcat

This project demonstrates a real-world CI/CD pipeline architecture on AWS using:
- **Jenkins** for build automation
- **SonarQube** for code quality analysis
- **Nexus** for artifact management
- **Tomcat** for application deployment
- **AWS VPC** for secure networking and **ALB** for load balancing

---

## 🧠 Project Goal

> To deploy a secure, end-to-end CI/CD pipeline using open-source DevOps tools on AWS infrastructure, simulating production-ready architecture with public-private subnet isolation and centralized traffic handling through Load Balancer.

---

## 🛠️ Tools & Services Used

| Tool / Service | Purpose                        |
|----------------|--------------------------------|
| **Jenkins**     | CI server to automate pipeline |
| **SonarQube**   | Code quality and static analysis |
| **Nexus**       | Artifact repository manager     |
| **Apache Tomcat** | Java application deployment     |
| **GitHub**      | Source code version control     |
| **AWS EC2**     | Compute infrastructure          |
| **AWS VPC**     | Secure network segmentation     |
| **AWS ALB**     | Load balancing HTTP traffic     |
| **NAT Gateway** | Internet access for private subnets |
| **Bastion Host / SSM** | Secure admin access to private resources |

---

## 📘 Day 1 – VPC Setup & Jenkins Configuration

### ✅ Objective
Set up a secure AWS network with public and private subnets, configure routing, and deploy Jenkins as the core of our CI/CD pipeline.

---

### 📌 Architecture Overview
- **VPC CIDR:** `192.168.0.0/22`
- **Public Subnets:** `192.168.0.0/24`, `192.168.1.0/24`
- **Private Subnets:** `192.168.2.0/24`, `192.168.3.0/25`
- **Reserved for future:** `192.168.3.128/26`, `192.168.3.192/26`

---

### 🌐 Network Configuration
- Created an **Internet Gateway** and attached it to the VPC.
- Configured **Route Tables**:
  - Public Subnet: Routed `0.0.0.0/0` to IGW.
  - Private Subnet: Routed internet traffic through a **NAT Gateway** (hosted in public subnet with EIP).
- Deployed an **Application Load Balancer** in the public subnet.

---

### 🧪 ALB Test
- Launched a test EC2 instance with **HTTPD** in the private subnet.
- Created a simple `index.html` inside `/var/www/html`.
- Registered the instance to the ALB’s **target group**.
- Successfully accessed the HTML page through the **ALB DNS name**.

---

### 🛠️ Jenkins Setup (in Private Subnet)
- Launched EC2 (Amazon Linux 2) in `192.168.2.0/24`.
- Installed Java 11 and Jenkins.
- Enabled and started Jenkins service.
- Accessed Jenkins via **SSH port-forwarding** or **Bastion Host**.
- Unlocked Jenkins and reached the setup dashboard.

```bash for jenkins setup
#!/bin/bash
sudo yum update -y
sudo yum install java-11-openjdk -y
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins
