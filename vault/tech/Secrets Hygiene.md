---
tags: [tech, security]
---

# Secrets Hygiene

Hard-learned lesson (a token was once committed at work before scanning existed). This repo is
PUBLIC — the rules are absolute, boring, and enforced by machines, not memory.

## The layers

1. **pre-commit gitleaks** (`.pre-commit-config.yaml`) — blocks the commit locally.
   `pip install pre-commit && pre-commit install` once per clone (Phase 1 step 2).
2. **CI gitleaks** (`.github/workflows/gitleaks.yml`) — full-history scan on every push,
   catches machines that skipped step 1.
3. **.gitignore** — `*.tfvars`, keys, kubeconfigs, `.env*` can't be staged by accident.
4. **Where secrets actually live**: GitHub Actions secrets (CI) · k8s secrets created by
   [[Terraform]] from variables passed at apply time (backends' tokens) · AI Studio/console
   dashboards (LLM keys) · laptop `~/.kube/config`.

## If a secret leaks anyway

Rotate FIRST (the provider console), then clean history (`git filter-repo`), then force-push.
Rotation beats history-scrubbing every time — the internet already cached the push.

Extra rule for the public repo: no home IPs, no home-network details in committed configs —
applies especially to [[Home Server Docker Stack]] notes.
