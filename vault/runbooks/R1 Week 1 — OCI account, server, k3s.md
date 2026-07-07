---
tags: [runbook, week1]
---

# R1 · Week 1 — OCI account → A1 server → k3s answering kubectl

Micro-steps: one action, one verify, no skipping. Legend: **[SANTI]** = his hands ·
**[GATE]** = decision · **[VERIFY-FIRST]** = check live before executing. Rules: `GUARDRAILS.md`.

## Pre-flight (all must be ✅ before step 1)

- [ ] HCP Terraform: org `sscleves-lab`, workspace `lab`, Execution Mode **Local**, token in
      GitHub secret `TF_API_TOKEN` AND `terraform login` done locally → verify:
      `cd C:\Repos\personal-lab\terraform\envs\lab; terraform init` says "HCP Terraform" and succeeds.
- [ ] Repo clean & current: `git status` clean, `git pull` done.
- [ ] werkplek tasks imported (tracking lives there).

## A. OCI account **[SANTI]** (~15 min)

1. Decide home region **[GATE]**: eu-marseille-1 (recommended) or eu-paris-1. Permanent choice.
2. https://signup.cloud.oracle.com → email + verify code → identity form → card (verify-only,
   ~$1 hold) → phone code → wait for "account provisioning" email (minutes to ~1 h).
3. First login → note the **tenancy name** and **home region** shown top-right.
   📸 the welcome screen.
4. **[GATE] The shape question**: menu ☰ → Compute → Instances → Create instance → Image &
   shape → Change shape → Ampere → note what `VM.Standard.A1.Flex` sliders allow
   (4 OCPU/24 GB or 2/12?) — **CANCEL the wizard** (we create via Terraform, not UI).
   Report the numbers → they set the RAM budget in [[03 Phase 2 — Cluster and Agones]].

## B. API auth for Terraform **[SANTI] + Claude** (~10 min)

5. Profile icon → My profile → **API keys** → Add API key → Generate key pair →
   **Download private key** → Save as `C:\Users\<user>\.oci\oci_api_key.pem` (NOT in any repo).
6. OCI shows a config snippet (user/fingerprint/tenancy OCIDs + region) → paste it to Claude
   (OCIDs are identifiers, not secrets) → Claude writes `C:\Users\<user>\.oci\config`.
7. Verify: `oci` CLI not needed — Terraform reads the same file. Gate passes when step 12's
   plan authenticates.

## C. The server, as code (Claude writes, Santi reads plans)

8. Claude fills `terraform/modules/oci-cluster`: VCN 10.0.0.0/16, public subnet, internet
   gateway, security list (22/tcp from home IP only **[SANTI: confirm current IP]**,
   80+443/tcp any, 7000-8000/udp any, 6443/tcp home IP), A1.Flex instance (shape from step 4,
   Ubuntu 24.04 **[VERIFY-FIRST: exact image OCID for the chosen region via OCI image list]**),
   cloud-init installing k3s.
9. `terraform fmt -recursive` → `terraform validate` → both clean.
10. Wire module into `envs/lab/main.tf` (uncomment) + variables (home IP, shape, image OCID).
11. PR flow: branch `week1-oci-cluster` → push → **[SANTI]** open PR → read the plan comment.
12. `terraform plan` locally too → expect ~8-12 adds, **0 destroys** → read aloud. **[GATE]**
13. Merge **[SANTI]** → apply runs in Actions (or locally if CI secrets not ready) →
    note output `public_ip`.
    - Failure "Out of host capacity" → see table below, don't churn retries blindly.

## D. k3s alive

14. `ssh ubuntu@<public_ip>` works **[SANTI or Claude]** → if timeout: security-list ingress
    vs home IP is the suspect, not k3s.
15. On the VM: `sudo systemctl status k3s` → active (running). If not: `sudo journalctl -u k3s -n 50`.
16. Kubeconfig to laptop: copy `/etc/rancher/k3s/k3s.yaml`, replace `127.0.0.1` with the
    public IP, save as `%USERPROFILE%\.kube\config` (NEVER in a repo — gitignored anyway).
17. Verify from Windows: `kubectl get nodes` → 1 node Ready. 📸 — **Week 1 done.**
18. Close-out: tick werkplek tasks, update HANDOFF-STATE, push.

## Failure table

| Symptom | Do |
|---|---|
| Out of host capacity (A1) | Try other Availability Domain → off-peak retry → [GATE] PAYG upgrade (still €0 in free shapes, priority placement) |
| Plan wants to DESTROY anything | STOP — read why with Santi before any apply |
| ssh timeout | Home IP changed? `curl ifconfig.me` and fix the security-list var, re-plan |
| kubectl x509/cert error | You forgot the 127.0.0.1 → public-IP replacement (step 16) |
| apply auth error | `.oci\config` path/fingerprint mismatch — re-check step 6 against the UI |

**Do NOT**: create anything via the OCI console wizard (Terraform only, or state drifts) ·
open 6443/22 to 0.0.0.0/0 · pick a non-A1 shape "just to test" (it bills).
