---
tags: [tech, platform]
---

# k3s

Single-binary Kubernetes; one server node on the [[OCI Always Free]] VM. Chosen over AKS because
AKS nodes are paid VMs — k3s on free compute is the only €0 Kubernetes ([[Azure Free Account]]).

## Install (Phase 2, via cloud-init in `terraform/modules/oci-cluster`)

```bash
curl -sfL https://get.k3s.io | sh -    # server+agent, single node
# kubeconfig: /etc/rancher/k3s/k3s.yaml → copy to laptop ~/.kube/config (NEVER the repo)
```

Minimums: 2 cores / 2 GB for the server (docs.k3s.io) — trivial on the A1 shape.

## Lab-specific notes

- [[Agones]] on k3s is community-proven (Linode's Xonotic guide) but NOT officially supported —
  pin versions, expect to debug alone.
- Traefik ships by default — fine for the site/chatbot ingress; game traffic bypasses it
  (hostPort UDP/WS via [[Agones]]).
- **Firewall, twice**: game ports must be open in the OCI VCN security list AND in the instance's
  iptables — Oracle's Ubuntu images ship restrictive host rules that silently eat UDP. #1 failure mode.
- Observability: [[OTel Collector]] runs as a deployment here; k8s events + kubelet metrics feed
  [[Dynatrace]] / [[New Relic]] k8s views.
