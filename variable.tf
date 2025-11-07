variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "web_subnet_cidr" {
  description = "Public subnet #1 for ALB/Web"
  type        = string
  default     = "10.0.1.0/24"
}

variable "web_subnet2_cidr" {
  description = "Public subnet #2 for ALB/Web (different AZ)"
  type        = string
  default     = "10.0.4.0/24"
}

variable "app_subnet_cidr" {
  description = "Private App subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "db_subnet_cidr" {
  description = "Private DB subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "ami_id" {
  description = "AMI for EC2 instances (Amazon Linux 2 in us-east-1)"
  type        = string
  default     = "ami-0c02fb55956c7d316"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Existing EC2 Key Pair name"
  type        = string
  default     = "my-key"
}
