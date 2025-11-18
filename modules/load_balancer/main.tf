# AWS Load Balancer
resource "aws_lb" "this" {
  count              = var.provider == "aws" ? 1 : 0
  name               = var.name
  internal           = var.internal
  load_balancer_type = var.lb_type
  subnets            = var.subnet_ids
  security_groups    = var.lb_type == "application" ? var.security_groups : null
}

resource "aws_lb_target_group" "this" {
  for_each = var.provider == "aws" ? var.target_groups : {}

  name     = each.key
  port     = each.value.port
  protocol = each.value.protocol
  vpc_id   = var.vpc_id

  health_check {
    path                = each.value.health_check.path
    protocol            = each.value.health_check.protocol
    interval            = each.value.health_check.interval
    timeout             = each.value.health_check.timeout
    healthy_threshold   = each.value.health_check.healthy_threshold
    unhealthy_threshold = each.value.health_check.unhealthy_threshold
  }
}

resource "aws_lb_target_group_attachment" "this" {
  for_each = var.provider == "aws" ? {
    for tg_name, tg in var.target_groups :
    tg_name => tg.targets
  } : {}

  count = length(each.value)

  target_group_arn = aws_lb_target_group.this[each.key].arn
  target_id        = each.value[count.index].id
  port             = each.value[count.index].port
}

resource "aws_lb_listener" "this" {
  for_each = var.provider == "aws" ? {
    for l in var.listeners : "${l.port}-${l.protocol}" => l
  } : {}

  load_balancer_arn = aws_lb.this[0].arn
  port              = each.value.port
  protocol          = each.value.protocol

  ssl_policy      = each.value.protocol == "HTTPS" ? each.value.ssl_policy : null
  certificate_arn = each.value.protocol == "HTTPS" ? each.value.certificate_arn : null

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[each.value.target_group].arn
  }
}

# Azure Load Balancer
resource "azurerm_lb" "this" {
  count               = var.provider == "azure" ? 1 : 0
  name                = var.name
  location            = var.region
  resource_group_name = var.resource_group
  sku                 = "Standard"

  frontend_ip_configuration {
    name = "frontend"

    public_ip_address_id = var.internal ? null : var.public_ip_id
    subnet_id            = var.internal ? var.subnet_ids[0] : null
    private_ip_address_allocation = var.internal ? "Dynamic" : null
  }
}

# GCP Load Balancer
resource "google_compute_forwarding_rule" "this" {
  count       = var.provider == "gcp" ? 1 : 0
  name        = var.name
  target      = google_compute_target_http_proxy.this[0].self_link
  port_range  = "80"
  ip_protocol = "TCP"

  load_balancing_scheme = var.internal ? "INTERNAL_MANAGED" : "EXTERNAL"
  network_tier          = var.internal ? "PREMIUM" : "STANDARD"
  ip_address            = var.ip_address
  subnetwork            = var.internal ? var.subnet_ids[0] : null
}

resource "google_compute_target_http_proxy" "this" {
  count      = var.provider == "gcp" ? 1 : 0
  name       = "${var.name}-proxy"
  url_map    = google_compute_url_map.this[0].self_link
}

resource "google_compute_url_map" "this" {
  count      = var.provider == "gcp" ? 1 : 0
  name       = "${var.name}-urlmap"
  default_service = google_compute_backend_service.this[0].self_link
}

resource "google_compute_backend_service" "this" {
  count      = var.provider == "gcp" ? 1 : 0
  name       = "${var.name}-backend"
  protocol   = "HTTP"
  port_name  = "http"
  timeout_sec = 30

  health_checks = [google_compute_health_check.this[0].self_link]
}

resource "google_compute_health_check" "this" {
  count      = var.provider == "gcp" ? 1 : 0
  name       = "${var.name}-hc"
  http_health_check {
    request_path = "/"
    port         = 80
  }
  check_interval_sec  = 10
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2
}