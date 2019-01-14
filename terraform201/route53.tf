resource "aws_route53_zone" "test_zone" {
  name = "${var.apex_domain}"

  tags = {
    Environment = "test"
  }
}

resource "aws_route53_record" "test_record" {
  depends_on = ["aws_lb.test_lb"]
  zone_id    = "${aws_route53_zone.test_zone.zone_id}"
  name       = "terraform-test.${var.apex_domain}"
  type       = "A"

  alias {
    name                   = "${aws_lb.test_lb.dns_name}"
    zone_id                = "${aws_lb.test_lb.zone_id}"
    evaluate_target_health = true
  }
}
