resource "netlify_site" "site" {
  name = "startpage-mdekort-nl"

  repo {
    repo_branch = "main"
    provider    = "github"
    repo_path   = "melvyndekort/startpage"
  }
}
