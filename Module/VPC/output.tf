output "vpc-id" {
    value = aws_vpc.mc-vpc.id
}

output "igw" {
  value = aws_internet_gateway.igw.*.id
}

output "public-subnet-ids" {
  description = "Public Subnets IDS"
  value       = aws_subnet.pub_sub.*.id
}

# Output of EIP For NAT Gateways

output "eip-ngw" {
  value = aws_eip.eip-ngw.*.id
}

# Output Of NAT-Gateways



# Output Of Private Subnet

output "private-subnet-ids" {
  description = "Private Subnets IDS"
  value       = aws_subnet.private_sub1.*.id
}