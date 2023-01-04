output "vpc_id" {
  value       = aws_vpc.packer.id
  description = "VPC ID"
}

output "packer_igw_id" {
  value       = aws_internet_gateway.packer.id
  description = "Internet Gateway ID"
}

output "packer_subnet_ids" {
  value       = aws_subnet.packer.*.id
  description = "List of public subnet IDs"
}

output "packer_route" {
  value       = aws_route.packer.id
  description = "Packer Route Table ID"
}

output "security_group_id" {
  value       = aws_security_group.packer.id
  description = "Security Group ID"
}

output "security_group_rule_icmp_ingress_id" {
  value       = aws_security_group_rule.packer_ingress_allow_icmp.id
  description = "ICMP Ingress Security Group ID"
}

output "security_group_rule_ssh_ingress_id" {
  value       = aws_security_group_rule.packer_ingress_allow_ssh.id
  description = "SSH Ingress Security Group ID"
}

output "security_group_rule_egress_id" {
  value       = aws_security_group_rule.packer_egress_allow_all.id
  description = "Security Group Egress ID"
}

output "packer_access_key" {
  value       = aws_iam_access_key.packer.id
  description = "Access Key ID"
}

output "packer_secret_key" {
  value       = aws_iam_access_key.packer.secret
  description = "Secret Key ID"
  sensitive   = true
}