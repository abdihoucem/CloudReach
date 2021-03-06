# Definir CIDR Block de VPC
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
# Definir CIDR Block de public Subnet 1
variable "public_subnet_cidr" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}
# Definir CIDR Block de private Subnet 1
variable "private_subnet_cidr" {
  type    = list(string)
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}
# Definir CIDR Block de db Subnet 1
variable "db_subnet_cidr" {
  type    = list(string)
  default = ["10.0.21.0/24", "10.0.22.0/24"]
}
# Definir Liste AZ
variable "availability_zone" {
  type    = list(string)
  default = ["eu-west-3a", "eu-west-3b"]
}
#Variables EC2
variable "ami_id" {
  description = "default ami"
  type        = string
  default     = "ami-08755c4342fb5aede"
}

variable "instance_type" {
  description = "default instance type"
  type        = string
  default     = "t2.micro"
}

#Variables Base des Données
variable "rds_instance" {
  type = map(any)
  default = {
    allocated_storage   = 10
    engine              = "mysql"
    engine_version      = "8.0.20"
    instance_class      = "db.t2.micro"
    multi_az            = false
    name                = "cloudreachdb"
    skip_final_snapshot = true
  }
}

#Sensitive variables de Base des Données
variable "db_username" {
  description = "Database administrator username"
  type        = string
  sensitive   = true
  default     = "root"
}

variable "db_password" {
  description = "Database administrator password"
  type        = string
  default     = "Test12345"
  sensitive   = true
}

#variable "dns_zone" {
#description = "domaine dans route53"
#}


variable "dns_name" {
  description = "domaine name"
  default     = "cloudreachtest.com"
}
variable "key_path" {
  default = "C:/Users/abdih/.ssh/id_rsa.pub"
}