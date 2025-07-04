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
#STEP-1: Installing Git and Maven
yum install git maven -y

#STEP-2: Repo Information (jenkins.io --> download -- > redhat)
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

#STEP-3: Download Java 17 and Jenkins
sudo rpm --import https://yum.corretto.aws/corretto.key
sudo curl -Lo /etc/yum.repos.d/corretto.repo https://yum.corretto.aws/corretto.repo
sudo yum install java-11-amazon-corretto -y

#STEP-4: Start and check the JENKINS Status
systemctl start jenkins.service
systemctl status jenkins.service

#STEP-5: Auto-Start Jenkins
chkconfig jenkins on
~


📘 Day 2 - Jenkins WAR Deployment & Tomcat Setup
🔧 Tasks Accomplished
Launched a New EC2 Instance for Tomcat

Instance launched in private subnet with appropriate security group rules (inbound: ports 22, 8081, 80 open to 0.0.0.0/0).

Created and associated a new Target Group (Tomcat-TG) with port 8081 for the Tomcat instance.

Tomcat Setup via Script
Executed the following tomcat-setup.sh script to install and run Apache Tomcat 11 on Amazon Linux 2023:

bash
Copy
Edit
#!/bin/bash

set -e
sudo yum update -y
sudo dnf install -y java-17-amazon-corretto

TOMCAT_VERSION=11.0.8
TOMCAT_DIR=/opt/tomcat
TOMCAT_USER=tomcat

sudo useradd -r -m -U -d $TOMCAT_DIR -s /bin/false $TOMCAT_USER
cd /tmp
curl -O https://dlcdn.apache.org/tomcat/tomcat-11/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz
sudo mkdir -p $TOMCAT_DIR
sudo tar -xf apache-tomcat-${TOMCAT_VERSION}.tar.gz -C $TOMCAT_DIR --strip-components=1

sudo chown -R $TOMCAT_USER:$TOMCAT_USER $TOMCAT_DIR
sudo chmod +x $TOMCAT_DIR/bin/*.sh

sudo tee /etc/systemd/system/tomcat.service > /dev/null <<EOL
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

User=$TOMCAT_USER
Group=$TOMCAT_USER

Environment="JAVA_HOME=$(dirname $(dirname $(readlink $(readlink $(which java)))))"
Environment="CATALINA_PID=$TOMCAT_DIR/temp/tomcat.pid"
Environment="CATALINA_HOME=$TOMCAT_DIR"
Environment="CATALINA_BASE=$TOMCAT_DIR"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"
Environment="JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom"

ExecStart=$TOMCAT_DIR/bin/startup.sh
ExecStop=$TOMCAT_DIR/bin/shutdown.sh

Restart=on-failure

[Install]
WantedBy=multi-user.target
EOL

sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable --now tomcat
sudo systemctl status tomcat
Fixed Tomcat Manager GUI Access

Edited tomcat-users.xml and context.xml to:

Enable remote GUI access

Add roles: manager-gui, manager-script, admin-gui

Add user credentials for deployment

Deployed WAR via Jenkins

Configured Jenkins Deploy to container plugin.

Fixed Maven command error (removed mvn from mvn package).

Verified WAR creation in target/ folder.

Jenkins deployed WAR successfully to /webapps directory of Tomcat via port 8081.

Load Balancer Integration

Listener configured for HTTP:8081 forwarding to Tomcat-TG

Verified deployment using curl and LB DNS.

✅ Day 2 Status: Completed

Next up: Nexus, SonarQube, final Jenkins pipeline and pushing everything to GitHub!!!
