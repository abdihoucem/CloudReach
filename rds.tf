resource "aws_db_subnet_group" "db_group_sub" {
  name       = "db_group_sub"
  subnet_ids = [aws_subnet.db-subnet[0].id, aws_subnet.db-subnet[1].id]
  tags = {
    Name = "DB subnet"
  }
}

resource "aws_db_instance" "cloudreachDB" {
  allocated_storage      = var.rds_instance.allocated_storage
  db_subnet_group_name   = aws_db_subnet_group.db_group_sub.id
  engine                 = var.rds_instance.engine
  engine_version         = var.rds_instance.engine_version
  instance_class         = var.rds_instance.instance_class
  multi_az               = var.rds_instance.multi_az
  username               = var.db_username
  password               = var.db_password
  skip_final_snapshot    = var.rds_instance.skip_final_snapshot
  vpc_security_group_ids = [aws_security_group.database-sg.id]
}
