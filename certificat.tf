resource "aws_route53_zone" "public" {
  name = var.dns_name
}

resource "aws_acm_certificate" "certificat" {

  domain_name       = var.dns_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "certificat" {
  certificate_arn         = aws_acm_certificate.certificat.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_route53_record" "cert_validation" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.certificat.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.certificat.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.certificat.domain_validation_options)[0].resource_record_type
  zone_id         = aws_route53_zone.public.id
  ttl             = 60
  provider        = aws.account_route53
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "certificat" {
  zone_id = aws_route53_zone.public.zone_id
  name    = var.dns_name
  type    = "CNAME"
  records = [
    "0 issue \"amazon.com\"",
    "0 issuewild \"amazon.com\""
  ]
  ttl = 60
}
