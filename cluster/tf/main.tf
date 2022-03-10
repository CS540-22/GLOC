terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}

data "cloudflare_zones" "benlg_dev" {
  filter {

  }
}

resource "cloudflare_record" "pale_0" {
  zone_id = lookup(data.cloudflare_zones.benlg_dev.zones[0], "id")
  name    = "*.homelab"
  value   = var.homelab_0_ip
  type    = "A"
  ttl     = 3600
}

resource "cloudflare_record" "pale_1" {
  zone_id = lookup(data.cloudflare_zones.benlg_dev.zones[0], "id")
  name    = "*.homelab"
  value   = var.homelab_1_ip
  type    = "A"
  ttl     = 3600
}

resource "cloudflare_record" "pale_2" {
  zone_id = lookup(data.cloudflare_zones.benlg_dev.zones[0], "id")
  name    = "*.homelab"
  value   = var.homelab_2_ip
  type    = "A"
  ttl     = 3600
}
