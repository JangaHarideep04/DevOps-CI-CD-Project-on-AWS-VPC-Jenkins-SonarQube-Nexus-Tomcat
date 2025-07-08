# 🛠️ DevOps CI/CD Architecture – AWS | Jenkins | SonarQube | Nexus | Tomcat

This repository demonstrates a complete CI/CD pipeline on AWS infrastructure using industry-standard DevOps tools. The architecture is designed with production-grade principles including public/private subnets, ALB routing, artifact/version control, and secure deployments.

---

## 📌 End-to-End Workflow Overview

```mermaid
graph LR
A[User] --> B[DNS URL of ALB]
B --> C[ALB in Public Subnet]
C --> D1[Jenkins in Private Subnet]
C --> D2[SonarQube in Private Subnet]
C --> D3[Nexus in Private Subnet]
C --> D4[Tomcat in Private Subnet]
