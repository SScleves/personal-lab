# Remote state in HCP Terraform (free tier) — replaced the Azure blob backend 2026-07-06
# after Azure account signup proved impossible (gmail/GitHub identity loop).
#
# BOOTSTRAP (Phase 1 step D):
# 1. Sign up at https://app.terraform.io/public/signup/account (email only, no card).
# 2. Create organization (e.g. "sscleves-lab") and workspace "lab".
# 3. Workspace → Settings → Execution Mode → LOCAL (HCP stores state + locks;
#    GitHub Actions / laptop runs terraform itself).
# 4. Uncomment the block below, set your org name, then `terraform init`.
# 5. User Settings → Tokens → create an API token → GitHub secret TF_API_TOKEN
#    (and locally: `terraform login`).
#
# terraform {
#   cloud {
#     organization = "sscleves-lab"
#     workspaces {
#       name = "lab"
#     }
#   }
# }
