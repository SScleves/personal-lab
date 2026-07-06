---
tags: [tech, data, stretch]
---

# MongoDB Atlas (stretch — game leaderboard + database observability)

The game needs one stateful thing to make persistence real: a **leaderboard**. Atlas M0 gives a
managed MongoDB free, and monitoring a real database turns into its own observability exercise.

## Free tier — ⚠️ NOT yet verified by a live check (do it at signup)

Community-known M0 terms: 512 MB storage, shared vCPU/RAM, 3-node replica set, deployable on
AWS/Azure/GCP regions, free forever, no card. **Verify on mongodb.com/pricing before relying on
numbers** — this note was written from secondary sources, unlike the rest of [[Free Tier Limits]].

## The build (1 evening)

1. Atlas signup (gmail) → M0 cluster in a nearby EU region → database user + IP allowlist
   (the OCI VM's egress IP only — never 0.0.0.0/0).
2. Connection string → k8s secret via [[Terraform]] ([[Secrets Hygiene]]).
3. agar.io-clone: top-10 scores collection, write on player death, read on lobby join.

## Exercises

1. Instrument the Mongo driver calls with [[OpenTelemetry]] spans — now a game trace shows
   `game → leaderboard.write → Atlas` end-to-end; find the slowest query in [[Dynatrace]].
2. Atlas's built-in metrics vs your OTel view: what does each see that the other can't?
   (One paragraph in the vendor-comparison doc.)
3. Chaos extra: block Atlas egress for 60 s (security-list rule) — does the game degrade
   gracefully? Does an SLO catch it? ([[Dynatrace SLOs]])
