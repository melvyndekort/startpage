resource "cloudflare_record" "site" {
  zone_id = data.terraform_remote_state.cloudsetup.outputs.mdekort_zone_id
  name    = "startpage"
  type    = "CNAME"
  ttl     = 1
  proxied = false
  value   = "startpage-mdekort-nl.netlify.app"
}
