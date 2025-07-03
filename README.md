# DevOps-AWS-Project
To build a CI/CD pipeline in AWS using Jenkins, SonarQube, Nexus, and Tomcat, deployed securely within a custom VPC, following real-world DevOps architecture practices.


**Day 1 Scope**


Set up the network architecture (VPC)

Create public and private subnets

Configure routing with Internet Gateway and NAT Gateway

Deploy and test an Application Load Balancer

Launch and configure Jenkins in a private subnet

**📍 VPC & Subnet Design**


Component	CIDR Range	Notes
VPC	192.168.0.0/22	Custom VPC for project
Public Subnet 1	192.168.0.0/24	For Load Balancer
Public Subnet 2	192.168.1.0/24	For redundancy/future use
Private Subnet 1	192.168.2.0/24	For Jenkins, app servers
Private Subnet 2	192.168.3.0/25	Additional private resources
Reserved Subnets	192.168.3.128/26, 192.168.3.192/26	For future scaling

**🌐 Networking Setup**

1. Internet Gateway
Created an Internet Gateway

Attached to the custom VPC

Public subnets associated with a Route Table that routes 0.0.0.0/0 to this gateway

2. NAT Gateway
Deployed NAT Gateway in one of the public subnets

Allocated and attached an Elastic IP

Updated Private subnet Route Table to forward 0.0.0.0/0 traffic to NAT Gateway (for outbound internet)

**🧪 Application Load Balancer Test**

Deployed a basic EC2 instance in private subnet

Installed Apache HTTPD and created index.html in /var/www/html

Registered the instance in an ALB target group

ALB listener on port 80 pointed to the target group

Successfully accessed the HTTP page via the Load Balancer DNS

**🔧 Jenkins Setup in Private Subnet**

EC2 Instance:
AMI: Amazon Linux 2

Subnet: 192.168.2.0/24 (private)

Instance Type: t2.medium

Security Group:

Port 8080 allowed from internal IPs

SSH access only from Bastion Host or SSM

**Jenkins Installation:**

bash
Copy
Edit
sudo yum update -y
sudo yum install java-11-openjdk -y
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins
Access Jenkins:
Used SSH tunneling or bastion host for internal access

**Retrieved unlock password:**

bash
Copy
Edit
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
Jenkins was successfully unlocked and ready

**🎯 Day 1 Achievements**

✅ VPC + Subnets fully configured

✅ Routing + NAT + IGW working

✅ Load Balancer verified with test app

✅ Jenkins installed and running in private subnet

