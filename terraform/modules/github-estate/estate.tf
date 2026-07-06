# github-estate — import-first management of the existing repos.
# ENABLE ONLY when: GITHUB_TOKEN PAT exists + you're ready to run the import → plan-to-zero drill.
# Everything below stays commented until then so `terraform validate` passes repo-wide.

# terraform {
#   required_providers {
#     github = {
#       source  = "integrations/github"
#       version = "~> 6.0"
#     }
#   }
# }
#
# provider "github" {
#   owner = "SScleves" # token via GITHUB_TOKEN env var
# }
#
# import {
#   to = github_repository.thetruth
#   id = "thetruth"
# }
#
# resource "github_repository" "thetruth" {
#   name        = "thetruth"
#   description = "Something Doesn't Fit — the book and the discussions"
#   visibility  = "public"
#
#   pages {                       # the setting that caused the 404 lesson, now as code
#     build_type = "legacy"       # deploy-from-branch
#     source {
#       branch = "main"
#       path   = "/"
#     }
#   }
# }
#
# import {
#   to = github_repository.personal_lab
#   id = "personal-lab"
# }
#
# resource "github_repository" "personal_lab" {
#   name        = "personal-lab"
#   description = "Observability lab: Terraform, k3s+Agones on OCI, OTel fan-out, Dynatrace/New Relic"
#   visibility  = "public"
# }
#
# resource "github_branch_protection" "personal_lab_main" {
#   repository_id = github_repository.personal_lab.node_id
#   pattern       = "main"
#   required_pull_request_reviews {} # PR required; solo repos: 0 approvals is fine
# }
#
# # Add werkplek + dutch-lessons the same way (import block + resource) once this pattern is proven.
