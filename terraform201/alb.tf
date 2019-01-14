resource "aws_lb" "test_lb" {
  name               = "terraform-test-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = ["${aws_subnet.test_subnets.0.id}"]

  enable_deletion_protection = true

  tags = {
    Environment = "test"
  }
}

resource "aws_lb_target_group" "test_lb_target_group" {
  name   = "terraform-test-lb-target-group"
  port   = "${var.target_group_port}"
  vpc_id = "${aws_vpc.test_vpc.id}"
}

resource "aws_acm_certificate" "test_cert" {
  domain_name       = "terraform-test.${var.apex_domain}"
  validation_method = "DNS"

  tags = {
    Environment = "test"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "test_lb_listener_https" {
  load_balancer_arn = "${aws_lb.test_lb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  certificate_arn   = "${aws_acm_certificate.test_cert.arn}"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.test_lb_target_group.arn}"
  }
}

resource "aws_lb_listener" "test_lb_listener_http" {
  load_balancer_arn = "${aws_lb.test_lb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
