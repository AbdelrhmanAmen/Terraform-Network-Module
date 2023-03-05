# fetch vpc information
data "aws_vpc" "vpc" {
    id = var.vpc
}

# create 2 private subnets using foreach 
resource "aws_subnet" "private_subnet" {
    for_each = var.private_subnets

    availability_zone_id = each.value["az"]
    cidr_block = each.value["cidr"]
    vpc_id     = data.aws_vpc.vpc.id

    tags = {
        Name = "${var.author}-${each.key}-private"
    }
}

#  create one public subnet, foreach is for future addition
resource "aws_subnet" "public_subnet" {
    for_each = var.public_subnets

    availability_zone_id = each.value["az"]
    cidr_block = each.value["cidr"]
    vpc_id     = data.aws_vpc.vpc.id

    tags = {
        Name = "${var.author}-${each.key}-public"
    }
}

# create an internet gatway in the vpc
resource "aws_internet_gateway" "gateway" {
    vpc_id = data.aws_vpc.vpc.id
    tags = {
        Name = "internet-gatway-${var.author}"
    }
}

# create a route table
resource "aws_route_table" "route" {
    vpc_id = data.aws_vpc.vpc.id

    tags = {
        Name = "route-table-${var.author}"
    }
}

# link the public subnet ,gateway and route table
resource "aws_route_table_association" "route-record-a" {
    for_each = aws_subnet.public_subnet
    subnet_id      = each.value.id
    route_table_id = aws_route_table.route.id
}

resource "aws_route_table_association" "route-record-b" {
    gateway_id     = aws_internet_gateway.gateway.id
    route_table_id = aws_route_table.route.id
}

# create a subnet group for RDS db subnet
resource "aws_db_subnet_group" "db_group" {
    name       = "db-group"
    subnet_ids = [for subnet in aws_subnet.private_subnet : subnet.id]
    tags = {
        Name = "db-subnet-${var.author}"
    }
}