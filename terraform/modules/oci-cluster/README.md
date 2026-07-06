# module oci-cluster (Phase 2)

Always-free Ampere A1 (4 OCPU / 24 GB / VM.Standard.A1.Flex) + VCN + security list opening:
22/tcp (admin), 80/443 (site/probes), 7000-8000/udp (Agones gameserver port range), 6443 (k3s API, restrict to home IP).

cloud-init installs k3s (single node, server+agent) and labels the node for Agones.
STAY inside always-free: one A1.Flex ≤ 4 OCPU/24 GB total, boot volume ≤ 200 GB, no paid add-ons.

Known issue: "Out of host capacity" for free A1 in busy regions — pick a quieter home region
or retry; region choice is permanent per tenancy, choose before signup.
