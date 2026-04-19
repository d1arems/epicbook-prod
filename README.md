The EpicBook: Automated Monolith Deployment

This repository contains the full Infrastructure as Code (IaC) and configuration management suite to deploy the EpicBook application. This project demonstrates a transition from manual server setup to a fully automated, idempotent, and production-ready monolith architecture.

# System Architecture
The deployment transforms a fresh Virtual Machine into a fully functional 3-tier environment:

Web Tier: Nginx acting as a Reverse Proxy to handle HTTP traffic and secure the application layer.

App Tier: Node.js (Express) backend managed by PM2 for process persistence and automated restarts.

Database Tier: MySQL Server with automated schema initialization and relational data seeding.

# Key Technical Implementations
Modular Ansible Roles: Logic is decoupled into common, nginx, and epicbook roles for high reusability and clean maintenance.

Dynamic Configuration: Utilizes Jinja2 templates to inject environment-specific variables into config/config.json, decoupling code from infrastructure secrets.

Idempotency & Resilience: Tasks are designed to be run multiple times without failure, featuring automatic process clearing (fuser) and conditional SQL execution.

Process Orchestration: Automated PM2 lifecycle management to ensure zero-downtime during application re-deployments.

# Getting Started

1. Provision: Use the terraform/ directory to spin up your cloud resources.

2. Configure Ansible
Ensure your ansible.cfg and inventory.ini are correctly set up in the ansible/ directory.

Bash
cd ../ansible

# Update inventory.ini with your VM IP
nano inventory.ini
3. Deploy the Application
Run the master playbook to install dependencies, configure the DB, and set up Nginx.

Bash
ansible-playbook site.yml
## Troubleshooting & Problem Resolutions
Problem 1: Ansible Role Tasks Not Found
Symptoms: Playbook finishes instantly after "Gathering Facts" with no tasks executed.
Cause: main.yml was in the role root instead of the tasks/ subdirectory.
Resolution:

Bash
mv roles/common/main.yml roles/common/tasks/main.yml
mv roles/epicbook/main.yml roles/epicbook/tasks/main.yml
mv roles/nginx/main.yml roles/nginx/tasks/main.yml
Problem 2: PM2 Binary Missing (rc 127)
Symptoms: pm2: not found error during the start task.
Cause: PM2 was not in the root PATH after npm installation.
Resolution: Explicitly installed PM2 globally and used the registered path.

YAML
- name: Install PM2
  npm: name=pm2 global=yes
- shell: "$(which pm2) start server.js --name epicbook"
Problem 3: Database Access Denied ('root'@'localhost')
Symptoms: 502 Bad Gateway / Node.js crash logs showing Access Denied for root.
Cause: The app ignored .env and used config/config.json hardcoded defaults.
Resolution: Templated the config.json file via Ansible to inject correct credentials.

Bash
# Manual check of the culprit file
cat /var/www/theepicbook/config/config.json
Problem 4: Port 8080 Conflict (EADDRINUSE)
Symptoms: Error: listen EADDRINUSE: address already in use :::8080.
Cause: Ghost processes or previous PM2 instances holding the port.
Resolution:

Bash
sudo fuser -k 8080/tcp
pm2 start server.js --name epicbook -f
## Final Verification
Bash
# Check if Nginx is passing traffic
curl -I http://<VM_IP>/

# Check App status
pm2 status
pm2 logs epicbook
"""

with open("README.md", "w") as f:
f.write(readme_content)

HTML for a professional PDF documentation
html_content = f"""

<!DOCTYPE html>

<html>
<head>
<style>
@page {{
size: A4;
margin: 15mm;
background-color: #ffffff;
}}
body {{
font-family: 'Helvetica', 'Arial', sans-serif;
color: #2d3436;
line-height: 1.5;
font-size: 11pt;
}}
.header {{
background-color: #0984e3;
color: white;
padding: 30px;
text-align: center;
border-radius: 5px;
margin-bottom: 25px;
}}
h1 {{ margin: 0; font-size: 22pt; }}
h2 {{ color: #0984e3; border-bottom: 1px solid #dfe6e9; padding-bottom: 5px; }}
h3 {{ color: #d63031; }}
pre {{
background-color: #2d3436;
color: #fab1a0;
padding: 12px;
border-radius: 4px;
font-size: 10pt;
}}
.issue-card {{
border: 1px solid #dfe6e9;
padding: 15px;
margin-bottom: 15px;
border-left: 5px solid #d63031;
background-color: #fffaf0;
}}
.footer {{
text-align: center;
font-size: 9pt;
color: #b2bec3;
margin-top: 50px;
}}
</style>
</head>
<body>
<div class="header">
<h1>EpicBook Deployment Ledger</h1>
<p>Project README & Troubleshooting Guide</p>
</div>

<section>
    <h2>Stepwise Execution</h2>
    <p>1. <strong>Infrastructure:</strong> Terraform was used to provision the Azure/AWS VM.</p>
    <pre>terraform apply -auto-approve</pre>
    
    <p>2. <strong>Configuration:</strong> Ansible organized into 3 roles (Common, Nginx, EpicBook).</p>
    <pre>ansible-playbook site.yml</pre>
</section>

<section>
    <h2>Technical Challenges & Solutions</h2>
    
    <div class="issue-card">
        <strong>1. Role Structure Error</strong>
        <p>Ansible roles require <code>tasks/main.yml</code>. We moved files from the role root into the correct subdirectory.</p>
    </div>

    <div class="issue-card">
        <strong>2. Database Connection (Sequelize)</strong>
        <p>The app crashed because <code>config/config.json</code> defaulted to root. We used an Ansible J2 template to overwrite this with <code>db_user</code> variables.</p>
    </div>

    <div class="issue-card">
        <strong>3. Port Conflict (8080)</strong>
        <p>Ghost processes caused <code>EADDRINUSE</code>. We used <code>fuser -k</code> to clear the port before <code>pm2 start</code>.</p>
    </div>
</section>

<div class="footer">
    Author: Oladayo Aremu | DevOps Deployment Project
</div>
</body>
</html>
&quot;&quot;&quot;

HTML(string=html_content).write_pdf("EpicBook_Project_Documentation.pdf")

```python?code_reference&code_event_index=5
from weasyprint import HTML

# Create the README.md content
readme_content = """# EpicBook Deployment Guide

This project automates the setup of a 3-tier Node.js application (EpicBook) on a single Ubuntu Virtual Machine.

## Directory Structure
Execution Steps
1. Provision Infrastructure (Terraform)
Bash
cd terraform
terraform init
terraform apply -auto-approve
2. Configure Ansible
Update the inventory.ini with your VM's Public IP and ensure ansible.cfg points to the correct roles path.

3. Run the Deployment
Bash
cd ../ansible
ansible-playbook site.yml
## Problems Encountered & Troubleshooting
1. "Empty" Playbook Finish
Problem: The playbook finished with ok=1 but executed 0 tasks.
Cause: The main.yml files were located in the role folder root instead of roles/[role]/tasks/main.yml.
Resolution:

Bash
mv roles/common/main.yml roles/common/tasks/main.yml
mv roles/epicbook/main.yml roles/epicbook/tasks/main.yml
mv roles/nginx/main.yml roles/nginx/tasks/main.yml
2. PM2 Command Not Found
Problem: Task failed with rc: 127 because the shell couldn't find pm2.
Cause: PM2 was installed globally but was not in the system's PATH during the Ansible session.
Resolution: Used which pm2 to find the absolute path and used it in the shell command.

Bash
sudo npm install pm2 -g
which pm2  # Output: /usr/bin/pm2
3. Database Access Denied ('root'@'localhost')
Problem: Node.js app crashed even with a valid .env file.
Cause: config/config.json was hardcoded to root.
Resolution: Templated the config.json file via Ansible to use variables.

Bash
# Verify config
cat /var/www/theepicbook/config/config.json
4. Port 8080 Already in Use (EADDRINUSE)
Problem: 502 Bad Gateway because the new app instance couldn't bind to port 8080.
Cause: A background process was still holding the port.
Resolution:

Bash
sudo fuser -k 8080/tcp
pm2 start server.js --name epicbook -f
## Post-Deployment Checks
Bash
pm2 status
curl -I http://localhost:8080
pm2 logs epicbook
"""

with open("README.md", "w") as f:
f.write(readme_content)

HTML for the PDF documentation
html_content = """

<!DOCTYPE html>

<html lang="en">
<head>
<meta charset="UTF-8">
<style>
@page {
size: A4;
margin: 15mm;
background-color: #f8f9fa;
}
body {
font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
line-height: 1.6;
color: #333;
margin: 0;
padding: 20px;
}
.header {
background-color: #2d3436;
color: #dfe6e9;
padding: 30px;
border-radius: 8px;
text-align: center;
margin-bottom: 30px;
}
h1 { margin: 0; font-size: 24pt; color: #fff; }
h2 { color: #0984e3; border-bottom: 2px solid #0984e3; padding-bottom: 5px; margin-top: 30px; }
h3 { color: #e17055; margin-top: 20px; }
pre {
background-color: #2d3436;
color: #55efc4;
padding: 15px;
border-radius: 5px;
font-family: 'Courier New', monospace;
font-size: 10pt;
overflow-x: auto;
}
.card {
background-color: #fff;
padding: 15px;
border-radius: 5px;
box-shadow: 0 2px 4px rgba(0,0,0,0.1);
margin-bottom: 20px;
border-left: 5px solid #0984e3;
}
.troubleshoot {
border-left: 5px solid #d63031;
}
.footer {
margin-top: 40px;
text-align: center;
color: #636e72;
font-size: 10pt;
}
</style>
</head>
<body>
<div class="header">
<h1>EpicBook Project Ledger</h1>
<p>Deployment Documentation & Troubleshooting History</p>
</div>

<section>
    <h2>1. Execution Workflow</h2>
    <div class="card">
        <p><strong>Step A:</strong> Initialize the infrastructure using Terraform to provision the VM.</p>
        <pre>terraform init && terraform apply</pre>
        
        <p><strong>Step B:</strong> Execute the modular Ansible playbook to configure the 3-tier stack.</p>
        <pre>ansible-playbook site.yml</pre>
    </div>
</section>

<section>
    <h2>2. Troubleshooting Journal</h2>
    
    <div class="card troubleshoot">
        <h3>Role Structure Issue</h3>
        <p><strong>Problem:</strong> Tasks were not recognized by Ansible.</p>
        <p><strong>Fix:</strong> Corrected directory nesting to <code>roles/&lt;role&gt;/tasks/main.yml</code>.</p>
    </div>

    <div class="card troubleshoot">
        <h3>Database Connection Refused</h3>
        <p><strong>Problem:</strong> App crashed with <i>Access denied for user 'root'</i>.</p>
        <p><strong>Fix:</strong> Templated the <code>config/config.json</code> to use specific DB user credentials instead of hardcoded defaults.</p>
    </div>

    <div class="card troubleshoot">
        <h3>EADDRINUSE: Port 8080</h3>
        <p><strong>Problem:</strong> Port was blocked by zombie processes.</p>
        <p><strong>Fix:</strong> Used <code>fuser -k 8080/tcp</code> and forced PM2 restart with <code>-f</code>.</p>
    </div>
</section>

<div class="footer">
    © 2026 EpicBook DevOps Project | Documentation by Oladayo Aremu
</div>
</body>
</html>
"""

HTML(string=html_content).write_pdf("EpicBook_Deployment_Guide.pdf")
print("Files generated successfully.")


[file-tag: code-generated-file-1-1776619849232916007]
[file-tag: code-generated-file-0-1776619849232911257]

The documentation includes the complete file structure I established, the specific Ansible commands for deployment, and a dedicated section on the four major hurdles we cleared:
1.  **Role Nesting:** Moving `main.yml` into the `tasks/` folder.
2.  **PM2 Pathing:** Resolving the `rc: 127` binary error.
3.  **Database Credentials:** Overwriting the `config/config.json` hardcoded root user.
4.  **Port Conflicts:** Using `fuser` and `pm2 -f` to resolve `EADDRINUSE`.

### Summary of Final Commands
To wrap up the project, remember these three "Golden Commands" for maintenance:
* **Check logs:** `pm2 logs epicbook`
* **Monitor resource usage:** `pm2 monit`
* **Restart everything clean:** `sudo fuser -k 8080/tcp && pm2 restart epicbook -f`
