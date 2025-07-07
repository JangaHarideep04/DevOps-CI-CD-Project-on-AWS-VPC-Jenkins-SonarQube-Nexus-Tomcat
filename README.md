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

---

# 📘 Day 2 – Tomcat Setup & WAR Deployment via Jenkins

### ✅ Objective

Install Apache Tomcat in a private EC2 instance and configure Jenkins to build & deploy a Maven WAR file.

---

### 🔧 Components Implemented

| Component     | Description                                                                 |
|---------------|-----------------------------------------------------------------------------|
| Apache Tomcat | Installed as deployment target for WAR files                                |
| Jenkins       | Builds and deploys WAR file                                                 |
| Target Group  | Port 8081 used to route traffic to Tomcat                                   |
| ALB           | Listener added for Tomcat endpoint                                          |

---

### 🧪 Tomcat Setup in Private Subnet

A new EC2 instance was launched in the private subnet (`192.168.3.0/25`), and Tomcat was installed using the following script:

```bash
#!/bin/bash
set -e

yum update -y
dnf install -y java-17-amazon-corretto

TOMCAT_VERSION=11.0.8
TOMCAT_DIR=/opt/tomcat
TOMCAT_USER=tomcat

useradd -r -m -U -d $TOMCAT_DIR -s /bin/false $TOMCAT_USER

cd /tmp
curl -O https://dlcdn.apache.org/tomcat/tomcat-11/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz
mkdir -p $TOMCAT_DIR
tar -xf apache-tomcat-${TOMCAT_VERSION}.tar.gz -C $TOMCAT_DIR --strip-components=1

chown -R $TOMCAT_USER:$TOMCAT_USER $TOMCAT_DIR
chmod +x $TOMCAT_DIR/bin/*.sh

tee /etc/systemd/system/tomcat.service > /dev/null <<EOL
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking
User=$TOMCAT_USER
Group=$TOMCAT_USER
Environment="JAVA_HOME=$(dirname $(dirname $(readlink $(readlink $(which java)))))"
Environment="CATALINA_HOME=$TOMCAT_DIR"
ExecStart=$TOMCAT_DIR/bin/startup.sh
ExecStop=$TOMCAT_DIR/bin/shutdown.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOL

systemctl daemon-reexec
systemctl daemon-reload
systemctl enable --now tomcat
systemctl status tomcat


---🧰 Jenkins WAR Deployment Steps
Jenkins Freestyle/Pipeline job created

GitHub project linked

Steps included:

mvn clean package

Deploy to Tomcat using Deploy to Container plugin

🔒 Tomcat Manager Access Fix
Edit the following files on the Tomcat instance:

tomcat-users.xml:

xml
Copy
Edit
<role rolename="manager-gui"/>
<role rolename="manager-script"/>
<role rolename="manager-jmx"/>
<role rolename="manager-status"/>
<role rolename="admin-gui"/>
<user username="admin" password="admin" roles="admin-gui,manager-gui,manager-script,manager-status"/>
context.xml:

xml
Copy
Edit
<Valve className="org.apache.catalina.valves.RemoteAddrValve" allow=".*" />
✅ Validation
WAR deployed to /opt/tomcat/webapps/myapp

Accessible at http://<ALB-DNS>:8081/myapp

Target group for port 8081 healthy

Jenkins build log shows successful deployment






