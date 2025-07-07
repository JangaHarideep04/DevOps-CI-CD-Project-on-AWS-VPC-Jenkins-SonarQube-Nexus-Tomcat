📡 AWS VPC Architecture – DevOps CI/CD Project

This README documents the custom AWS VPC structure created for a full-stack CI/CD pipeline project involving Jenkins, SonarQube, Nexus, and Tomcat.

🧱 Project Scope: VPC Networking for CI/CD

This setup is part of a secure, production-style architecture built from scratch using EC2, ALB, custom subnets, NAT gateway, and more — providing secure public-private isolation for various DevOps tools.

🌐 VPC CIDR & Subnetting

VPC Element

CIDR Range

Purpose

VPC

192.168.0.0/22

Main network range

Public Subnet 1

192.168.0.0/24

ALB, Bastion, NAT Gateway

Public Subnet 2

192.168.1.0/24

Multi-AZ Load Balancer

Private Subnet 1

192.168.2.0/24

Jenkins, SonarQube

Private Subnet 2

192.168.3.0/25

Tomcat, Nexus

Reserved Future

192.168.3.128/26

Reserved for scaling

Reserved Future

192.168.3.192/26

Reserved for scaling

📌 Components Mapped to Subnets

Component

Subnet

Accessibility

ALB (HTTP/8081/9000/8082)

Public Subnet 1 & 2

Public

Jenkins

Private Subnet 1 (192.168.2.0/24)

Private via ALB

SonarQube

Private Subnet 1

Private via ALB

Nexus

Private Subnet 2

Private via ALB

Tomcat

Private Subnet 2

Private via ALB

NAT Gateway

Public Subnet 1

Shared internet for private instances

Bastion/SSM

Public Subnet 1

Admin Access

🔁 Routing Strategy

Public Route Table: 0.0.0.0/0 → IGW

Private Route Table: 0.0.0.0/0 → NAT Gateway

Subnet associations and ACLs handled manually

⚙️ Load Balancer Configuration

Listener Port

Target Group Target

Health Check Path

8081

Tomcat Instance

/myapp/

8082

Nexus Repo

/

9000

SonarQube

/projects

📷 Snapshot Uploads (To be added manually)

Please add screenshots for the following via GitHub after creating /assets folder:

VPC CIDR block and subnets overview

Internet Gateway and NAT Gateway setup

Route tables and their associations

Load Balancer config and listeners

EC2 instances mapped to correct subnets

Target Groups and health checks

📁 Suggested image folder structure:

/assets/vpc-cidr.png
/assets/subnets-overview.png
/assets/nat-gateway.png
/assets/route-tables.png
/assets/alb-listeners.png
/assets/target-groups.png
/assets/ec2-subnet-mapping.png

✅ Final Validation

All components are properly isolated in private subnets

ALB routes requests to Jenkins, Tomcat, Nexus, SonarQube

NAT gateway allows private instances to access the internet

Project deploys end-to-end from GitHub → Jenkins → Sonar → Nexus → Tomcat
