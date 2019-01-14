resource "aws_launch_configuration" "test_lc" {
  name_prefix   = "terraform-test-lc-"
  image_id      = "${var.ami_id}"
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "test_asg" {
  name                 = "terraform-test-asg"
  launch_configuration = "${aws_launch_configuration.test_lc.name}"
  min_size             = "${var.asg_min_size}"
  max_size             = "${var.asg_max_size}"
  desired_capacity     = "${var.asg_desired_size}"
  vpc_zone_identifier  = ["${slice(aws_subnet.test_subnets.*.id, 1, length(aws_subnet.test_subnets.*.id))}"]
  target_group_arns    = ["${aws_lb_target_group.test_lb_target_group.arn}"]
/*
  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = "${var.on_demand_base_capacity}"
      on_demand_percentage_above_base_capacity = "${var.on_demand_percentage_above_base_capacity}"
    }

    launch_template {}
  }
*/
  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name = "terraform_test_asg"
  }
}
