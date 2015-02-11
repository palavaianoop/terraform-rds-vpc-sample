variable "cidr_home" {}

resource "aws_db_instance" "default" {
    identifier = "mydb-rds"
    allocated_storage = 10
    engine = "mysql"
    engine_version = "5.6.21"
    instance_class = "db.t1.micro"
    name = "mydb"
    username = "foo"
    password = ""  # NOTE: We have to empty this after creation because of update
    #security_group_names = ["${aws_db_security_group.bar.name}"]
    vpc_security_group_ids = ["sg-56736734", "sg-f1283193", "sg-7c2d361e", "${aws_security_group.home.id}"]
    db_subnet_group_name = "${aws_db_subnet_group.default.name}"
    parameter_group_name = "${aws_db_parameter_group.default.name}"

    # NOTE: to destroy, we need either
    skip_final_snapshot = true
    final_snapshot_identifier = "foo"

    # Optional, but actually we need next because of update
    availability_zone = "ap-northeast-1a"
    backup_retention_period = "1"
    backup_window = "19:59-20:29"
    maintenance_window = "mon:13:07-mon:13:37"
    multi_az = false
    port = 3306
}

resource "aws_security_group" "home" {
    name = "home"
    description = "sg home"
    vpc_id = "vpc-148a8176"
    ingress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = ["${var.cidr_home}"]
    }
}

resource "aws_db_subnet_group" "default" {
    name = "main"
    description = "Our main group of subnets"
    subnet_ids = ["subnet-37a6a143", "subnet-66c29820"]
}

resource "aws_db_parameter_group" "default" {
    name = "rds-pg"
    family = "mysql5.6"
    description = "RDS default parameter group"

    parameter {
      name = "character_set_server"
      value = "utf8"
    }

    parameter {
      name = "character_set_client"
      value = "utf8"
    }
}
