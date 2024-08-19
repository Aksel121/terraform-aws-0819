resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr_block
}

resource "aws_security_group" "default" {
  name        = "my_first_sg"
  description = "testing security group"
  vpc_id      = aws_vpc.my_vpc.id

  dynamic "ingress" {
    for_each = [for rule in var.sg_rules : rule if rule.type == "ingress"]
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
  }

  dynamic "egress" {
    for_each = [for rule in var.sg_rules : rule if rule.type == "egress"]
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
      description = egress.value.description
    }
  }
}

output "my_vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "security_group_id" {
  value = aws_security_group.default.id
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "sg_rules" {
  description = "Security group rules"
  type = list(object({
    type        = string
    from_port   = number
    to_port     = number
    protocol    = optional(string, "-1")
    cidr_blocks = list(string)
    description = string
  }))
  default = []
}


 



 
 
