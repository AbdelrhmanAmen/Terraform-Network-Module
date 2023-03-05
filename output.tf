
output "public" {
    value = aws_subnet.public_subnet["subnet-3"].id
}

output "private" {
    value =  aws_db_subnet_group.db_group.id
}