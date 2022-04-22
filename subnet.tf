# Définir Public Subnet
resource "aws_subnet" "public-subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = var.public_subnet_cidr[count.index]
  availability_zone       = var.availability_zone[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet -${count.index + 1}"
  }
}
# Définir Private Subnet
resource "aws_subnet" "private-subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = var.private_subnet_cidr[count.index]
  availability_zone       = var.availability_zone[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "Private Subnet -${count.index + 1}"
  }
}
# Définir DB Subnet
resource "aws_subnet" "db-subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = var.db_subnet_cidr[count.index]
  availability_zone       = var.availability_zone[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "DB Subnet -${count.index + 1}"
  }
}
