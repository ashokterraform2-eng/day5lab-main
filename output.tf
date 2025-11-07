# ALB URL (main public entry)
output "app_load_balancer_url" {
  description = "Public URL of Application Load Balancer"
  value       = "http://${aws_lb.app_alb.dns_name}"
}

# Optional: Web instance direct URLs (for quick tests)
output "web_tier_urls" {
  description = "Public URLs for Web Tier EC2s"
  value       = [for ip in aws_instance.web[*].public_ip : "http://${ip}"]
}

# Private IPs for internal debugging / templating visibility
output "app_tier_private_ips" {
  description = "App EC2 private IPs"
  value       = aws_instance.app[*].private_ip
}

output "db_private_ip" {
  description = "DB EC2 private IP"
  value       = aws_instance.db.private_ip
}
