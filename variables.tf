variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "vpc_cidr" {
	default = "10.0.0.0/16"
}

variable "azs" {
	type = list
	default = ["us-east-1a", "us-east-1b"]
}

variable "subnets_cidr_public" {
	type = list
	default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "subnets_cidr_private" {
  type = list
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "ip" {
  type = string
  description = "my public ip"
}

variable "servers" {
  description = "The number of consul servers."
  default = 3
}

variable "clients" {
  description = "The number of consul client instances"
  default = 2
}

variable "consul_version" {
  description = "The version of Consul to install (server and client)."
  default     = "1.4.0"
}

variable "ami" {
  description = "ami to use - based on region"
  default = {
    "us-east-1" = "ami-04b9e92b5572fa0d1"
    "us-east-2" = "ami-0d5d9d301c853a04a"
  }
}

variable "prometheus_dir" {
  description = "directory for prometheus binaries"
  default = "/opt/prometheus"
}

variable "prometheus_conf_dir" {
  description = "directory for prometheus configuration"
  default = "/etc/prometheus"
}

variable "promcol_version" {
  description = "Prometheus Collector version"
  default = "2.16.0"
}

variable "node_exporter_version" {
  description = "Node Exporter version"
  default = "0.18.1"
}

variable "apache_exporter_version" {
  description = "Apache Exporter version"
  default = "0.7.0"
}
