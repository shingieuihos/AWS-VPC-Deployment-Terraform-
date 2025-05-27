output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = [aws_subnet.web_servers.id, aws_subnet.accounting.id]
}

output "private_subnet" {
  value = aws_subnet.operations.id
}
