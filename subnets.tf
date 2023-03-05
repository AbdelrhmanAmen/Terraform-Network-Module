data "aws_vpc" "vpc" {
    id = var.vpc
}

resource "aws_subnet" "private_subnet" {
    for_each = var.private_subnets

    availability_zone_id = each.value["az"]
    cidr_block = each.value["cidr"]
    vpc_id     = data.aws_vpc.vpc.id

    tags = {
        Name = "${var.author}-${each.key}-private"
    }
}

resource "aws_subnet" "public_subnet" {
    for_each = var.public_subnets

    availability_zone_id = each.value["az"]
    cidr_block = each.value["cidr"]
    vpc_id     = data.aws_vpc.vpc.id

    tags = {
        Name = "${var.author}-${each.key}-public"
    }
}

resource "aws_internet_gateway" "gateway" {
    vpc_id = data.aws_vpc.vpc.id
    tags = {
        Name = "internet-gatway-${var.author}"
    }
}

resource "aws_route_table" "route" {
    vpc_id = data.aws_vpc.vpc.id

    tags = {
        Name = "route-table-${var.author}"
    }
}

resource "aws_route_table_association" "route-record-a" {
    depends_on = [
        aws_subnet.public_subnets
    ]
    for_each = var.public_subnets
    subnet_id      = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.route.id
}

resource "aws_route_table_association" "route-record-b" {
    gateway_id     = aws_internet_gateway.gateway.id
    route_table_id = aws_route_table.route.id
}
