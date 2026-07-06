---
tags: [tech, cloud]
---

# Azure Free Account

Role in the lab: the **work-mirror** — [[Terraform]] remote state (blob), Dutch-lessons static site
hosting, one tiny probe VM. NOT the cluster host (free VMs are too small — that's [[OCI Always Free]]).

## Verified numbers (2026-07-06, sources in [[Free Tier Limits]])

- $200 credit / 30 days · ~55 services free 12 months · always-free list. Nothing auto-charges
  until you explicitly upgrade to pay-as-you-go; account disables instead.
- Free VMs: **B1s, B2pts v2 (Arm), B2ats v2 (AMD)** — 750 h/month pooled, 12 months, ~1 GiB RAM class.
  Must be created via the portal's **Free services** flow or they bill anyway. Use `smalldisk` images
  (free disk allowance = 2×64 GB P6; default images are 127 GB).
- Blob for tfstate: 5 GB free 12 months, then a few-KB state ≈ <$0.05/mo. Keep LRS, versioning off.
- AKS control plane is free forever but nodes are paid VMs → [[k3s]] instead.

## ⚠️ The month-13 trap

After PAYG upgrade, the VM that was free in month 12 **silently bills in month 13**.
Calendar reminder at month 11 is a Phase 1 step, not a nice-to-have.

Signup: credit card (verification, ~$1 hold) + phone; one free account per person.
