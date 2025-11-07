#!/bin/bash
set -e

# Install Apache + Proxy Modules
sudo yum update -y
sudo yum install -y httpd mod_proxy mod_proxy_http

# Enable & Start Apache
sudo systemctl enable httpd
sudo systemctl start httpd

# Basic Identity Page
echo "<h1>Hello from Web Server $(hostname)</h1>" > /var/www/html/index.html

# Create Proxy Load Balancing Config using Terraform-injected IP variables
sudo tee /etc/httpd/conf.d/proxy.conf > /dev/null <<EOF
<VirtualHost *:80>
    ProxyPreserveHost On

    # Trace proof that request passed through Web Tier
    RequestHeader set X-Forwarded-By "Web-Tier-Apache"

    <Proxy balancer://appcluster>
        BalancerMember http://${app1_ip}:8080
        BalancerMember http://${app2_ip}:8080
        ProxySet lbmethod=byrequests
    </Proxy>

    ProxyPass / balancer://appcluster/
    ProxyPassReverse / balancer://appcluster/
</VirtualHost>
EOF

# Restart Apache to apply config
sudo systemctl restart httpd