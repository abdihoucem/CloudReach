# Internet Gateway
resource "aws_internet_gateway" "Internet-gateway" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "Internet-gateway"
  }
}

#Route table 
resource "aws_route_table" "web-routeTable" {
  vpc_id = aws_vpc.my-vpc.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Internet-gateway.id
  }

  tags = {
    Name = "Route Table"
  }
}

# Create Web Subnet association with Web route table
resource "aws_route_table_association" "public_subnet_1" {
  subnet_id      = aws_subnet.public-subnet[0].id
  route_table_id = aws_route_table.web-routeTable.id
}

resource "aws_route_table_association" "public_subnet_2" {
  subnet_id      = aws_subnet.public-subnet[1].id
  route_table_id = aws_route_table.web-routeTable.id
}