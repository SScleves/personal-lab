# module azure-state (Phase 1)

Resource group + storage account (LRS! not GRS — €0 rule) + `tfstate` blob container.

Bootstrap: apply this module with LOCAL state first, then uncomment `backend.tf` in envs/lab
and run `terraform init -migrate-state`. Keep versioning/soft-delete OFF (snapshot storage bills).

Cost check: a few-KB state + daily plans ≈ <$0.05/month even after the 12-month free window.
