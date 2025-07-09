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



---

🔄 Workflow Description
✅ User Access
User hits the ALB DNS URL in the browser.

ALB routes requests to the appropriate target based on port listener:

Port 8080 → Jenkins

Port 8081 → Tomcat

Port 8082 → Nexus

Port 9000 → SonarQube

🌐 Public Subnet
Hosts the Application Load Balancer (ALB) and NAT Gateway.

ALB acts as a central traffic manager for incoming user requests.

NAT Gateway provides outbound internet access to private subnet instances.

🔐 Private Subnet
Jenkins: Orchestrates the CI/CD pipeline and automation process.

SonarQube: Performs static code analysis and quality checks.

Nexus: Serves as the artifact repository for WAR files.

Tomcat: Acts as the final deployment environment for the web application.

🔁 CI/CD Pipeline Flow
Jenkins pulls the latest source code from GitHub.

Executes build and unit tests using Maven.

Performs static analysis using SonarQube.

Packages the project and generates a .war file.

Uploads the artifact to Nexus Repository.

Automatically deploys the WAR to Tomcat Server via plugin.

Application is served through the ALB DNS URL at port 8081.
