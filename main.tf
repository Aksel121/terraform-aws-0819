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


variable "name" {
  description = "The name of the security group"
  type        = string
}
 
variable "description" {
  description = "The description of the security group"
  type        = string
}
 
variable "vpc_id" {
  description = "The VPC ID where the security group will be created"
  type        = string
}
 
variable "sg_rules" {
  description = "A list of security group rules for ingress and egress"
  type = list(object({
    type        = string                      # "ingress" or "egress"
    from_port   = number                      # Port range start
    to_port     = number                      # Port range end
    protocol    = string                      # Protocol, e.g., "tcp", "udp", "-1" (for all)
    cidr_blocks = optional(list(string))      # CIDR blocks (optional)
    description = optional(string)            # Description of the rule (optional)
  }))
  default = []
}
 
variable "tags" {
  description = "A map of tags to assign to the security group"
  type        = map(string)
  default     = {}
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}


 
 
