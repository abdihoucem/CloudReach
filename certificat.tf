
data "aws_route53_zone" "public" {
  name         = var.dns_zone
  private_zone = false
  provider     = aws.account_route53
}

resource "tls_private_key" "certificat" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "certificat" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.certificat.private_key_pem

  subject {
    common_name  = "option1.co.uk"
    organization = "ACME CloudReach, Inc"
  }

  validity_period_hours = 12

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "certificat" {

  domain_name       = aws_route53_record.certificat.fqdn
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "certificat" {
  certificate_arn         = aws_acm_certificate.certificat.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]

}

resource "aws_route53_record" "cert_validation" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.certificat.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.certificat.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.certificat.domain_validation_options)[0].resource_record_type
  zone_id         = data.aws_route53_zone.public.id
  ttl             = 60
  provider        = aws.account_route53
}
resource "aws_route53_record" "certificat" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = "${var.dns_name}.${data.aws_route53_zone.public.name}"
  type    = "A"
  alias {
    name                   = aws_alb.ELB-Web.dns_name
    zone_id                = aws_alb.ELB-Web.zone_id
    evaluate_target_health = false
  }
  provider = aws.account_route53
}
