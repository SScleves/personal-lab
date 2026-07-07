---
tags: [runbook, week2]
---

# R2 · Week 2 — arm64 image → Agones fleet → chaos on a schedule

Pre-flight: R1 fully green (`kubectl get nodes` Ready from the laptop) · Docker Desktop or
docker engine available on the build machine · GHCR login **[SANTI]**: classic PAT with
`write:packages` → `docker login ghcr.io -u SScleves` (token via env var, never a file in a repo).

## A. The game image, the right architecture

1. Clone the game: `git clone https://github.com/owenashurst/agar.io-clone.git C:\Repos\SScleves\agario-lab`
   (their code, our container) → `npm install; npm start` locally → play on localhost:3000. 📸
2. **The deliberate lesson**: build WITHOUT platform flag, deploy to cluster, watch
   `exec format error` in `kubectl logs` — now ARM is understood viscerally. (Optional but recommended once.)
3. Real build: `docker buildx create --use` (once) →
   `docker buildx build --platform linux/arm64 -t ghcr.io/sscleves/agario-lab:0.1.0 --push .`
4. Verify manifest: `docker manifest inspect ghcr.io/sscleves/agario-lab:0.1.0` shows arm64.
5. **[SANTI]** ghcr.io package page → change package visibility to Public (or add a k8s
   imagePullSecret — Public is simpler, the code is MIT anyway). **[GATE]**
6. Plain-pod smoke test: `kubectl run agario --image=ghcr.io/sscleves/agario-lab:0.1.0 --port 3000`
   → `kubectl logs agario` shows the server listening → delete the pod.

## B. Agones, pinned

7. **[VERIFY-FIRST]** current Agones version + helm values for arm64 at agones.dev/site/docs/installation
   (arm64 is Alpha — the exact flags may have moved since 2026-07).
8. `helm repo add agones https://agones.dev/chart/stable && helm repo update`
9. `helm install agones agones/agones -n agones-system --create-namespace --version <pinned>`
10. Verify: `kubectl get pods -n agones-system` all Running; `kubectl get crd | findstr agones`
    shows gameservers/fleets/fleetautoscalers.
11. Smoke test with the ONLY guaranteed-arm64 example:
    `kubectl create -f https://raw.githubusercontent.com/googleforgames/agones/release-<ver>/examples/simple-game-server/gameserver.yaml`
    → `kubectl get gameservers` reaches **Ready** → note its IP:PORT →
    test echo per Agones docs → delete it.
    UDP fails? → security list 7000-8000/udp AND `sudo iptables -L` on the VM (Oracle images
    ship restrictive host rules — the #1 failure, see [[Agones]]).

## C. The real fleet + autoscaler

12. Claude writes `k8s/agario-fleet.yaml`: Fleet (replicas 2, our image, containerPort 3000,
    **[VERIFY-FIRST]** the game needs no Agones SDK calls to sit Ready? if it does, wrap with
    the sidecar `--is-local` pattern or add the SDK ping — check current Agones docs on
    "gameservers without SDK") + FleetAutoscaler (Buffer policy, bufferSize 1, min 2, max 5).
13. `kubectl apply -f k8s/agario-fleet.yaml` → `kubectl get fleet` 2/2 Ready.
14. Play it from the laptop browser (IP:hostPort from `kubectl get gameservers`). 📸 two browsers.

## D. Chaos, scheduled

15. `k8s/chaos-cron.yaml`: CronJob `*/10 * * * *`, ServiceAccount+Role to delete pods in
    default ns, image bitnami/kubectl (**[VERIFY-FIRST]** arm64 tag), command: delete one
    random pod labelled as gameserver.
16. Apply → wait for a run → `kubectl get gameservers -w` shows a kill and Agones replacing it. 📸
17. **Week 2 done** when: fleet self-heals on schedule + a human can always reconnect.
    Close-out per protocol (werkplek ticks, HANDOFF, push).

**Do NOT**: use Bedrock or Xonotic images (ARM-broken/unverified — [[Game Servers]]) ·
run chaos more often than the SLO windows can absorb (Week 3 needs clean burn signals) ·
skip the version pin on Agones.
