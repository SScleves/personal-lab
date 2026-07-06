---
tags: [tech, platform]
---

# Docker

Everything on the cluster is a container, and the [[OCI Always Free]] server is **ARM64** —
so the one Docker skill this lab drills hard is **multi-arch builds**. Images live on **GHCR**
(GitHub Container Registry — free for public repos, same login you already have).

## The build that matters (Week 2, gates the whole game fleet)

```bash
# once per machine
docker buildx create --use
# from the agar.io-clone checkout — build FOR THE SERVER's architecture and push
docker buildx build --platform linux/arm64 \
  -t ghcr.io/sscleves/agario-lab:0.1.0 --push .
```

Auth: `docker login ghcr.io -u SScleves` with a GitHub PAT (`write:packages` scope) —
the PAT is a secret ([[Secrets Hygiene]]): env var, never the repo.

## Exercises

1. **The arm64 lesson**: build the image WITHOUT `--platform` on your amd64 laptop, deploy to the
   cluster, watch `exec format error` in the pod logs — now you've *seen* the bug the whole
   ARM constraint is about. Rebuild correctly.
2. **Multi-stage shrink**: node:22 → node:22-alpine multi-stage; measure image size before/after
   (`docker images`), and pod startup time — smaller images = faster [[Agones]] respawns,
   which is a real SLO input.
3. **Read a Dockerfile like a reviewer**: the itzg/minecraft-server Dockerfile — find where it
   handles multi-arch and what its healthcheck does.
4. Wire the build into [[GitHub Actions]]: on tag push, buildx + push to GHCR — the same
   plan/apply pedagogy, applied to images.

Home context: your [[Home Server Docker Stack]] is compose-based amd64 — different arch,
same concepts; the collector container you add there is exercise 4's image reused.
