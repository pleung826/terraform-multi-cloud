output "app_dns_names" {
  value = {
    for k, m in module.apps : k => m.dns_name
  }
}