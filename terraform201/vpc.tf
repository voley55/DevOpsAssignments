resource "aws_vpc" "test_vpc" {
  cidr_block = "${var.network_base_cidr}"

  tags = {
    Name = "terraform_test_vpc"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "test_subnets" {
  count      = "${length(data.aws_availability_zones.available.names)}"
  vpc_id     = "${aws_vpc.test_vpc.id}"
  cidr_block = "${cidrsubnet(var.network_base_cidr, ceil(log(length(data.aws_availability_zones.available.names), 2)), count.index)}"

  tags = {
    Name = "${format("terraform_test_sub-%s", data.aws_availability_zones.available.names[count.index])}"
  }
}

resource "aws_internet_gateway" "test_igw" {
  vpc_id = "${aws_vpc.test_vpc.id}"

  tags = {
    Name = "terraform_test_igw"
  }
}

resource "aws_eip" "test_eip" {
  vpc = true

  tags = {
    Name = "terraform_test_eip"
  }

  depends_on = ["aws_internet_gateway.test_igw"]
}

resource "aws_nat_gateway" "test_ngw" {
  allocation_id = "${aws_eip.test_eip.id}"
  subnet_id     = "${element(aws_subnet.test_subnets.*.id, 0)}"

  tags = {
    Name = "terraform_test_ngw"
  }

  depends_on = ["aws_internet_gateway.test_igw"]
}

resource "aws_route_table" "test_public" {
  vpc_id = "${aws_vpc.test_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.test_igw.id}"
  }

  tags {
    Name = "terraform_test_public_subnet_route_table"
  }

  depends_on = ["aws_internet_gateway.test_igw"]
}

resource "aws_route_table" "test_private" {
  vpc_id = "${aws_vpc.test_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.test_ngw.id}"
  }

  tags {
    Name = "terraform_test_private_subnet_route_table"
  }

  depends_on = ["aws_nat_gateway.test_ngw"]
}

resource "aws_route_table_association" "test_route_association" {
  count          = "${length(data.aws_availability_zones.available.names)}"
  subnet_id      = "${element(aws_subnet.test_subnets.*.id, count.index)}"
  route_table_id = "${ count.index == 0 ? aws_route_table.test_public.id : aws_route_table.test_private.id}"
}
