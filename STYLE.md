# STYLE.md — how Santi likes things documented and commented

Extracted from this repo's actual practice. Any doc or code written for Santi follows this —
it's not taste, it's what keeps multi-machine, multi-session, multi-model work from rotting.

## Documentation

1. **Ridiculously Small steps.** One action per step, the exact command or the exact URL and
   button name. A step a beginner can't execute in under a minute is two steps.
2. **Every step carries its verify.** "Do X" is half a step; "Do X → check Y says Z" is a step.
3. **Mark whose hands**: **[SANTI]** browser/signup/push · **[GATE]** his decision ·
   **[VERIFY-FIRST]** an assumption to check live before executing. Never guess UI labels,
   endpoints, versions, prices — verify or mark.
4. **Where-it-bites rule.** Never state a limit without saying where it bites THIS project
   ("750 h = exactly one VM 24/7, zero headroom"). A limit without consequence is trivia.
5. **Verify-live with dates.** Facts from vendor pages carry "✅ verified YYYY-MM-DD".
   Stale facts get re-verified, not trusted. Training-data numbers are never facts.
6. **Failures are documentation.** Every real failure becomes a troubleshooting-table row
   (symptom → cause → fix). The best guides here are autopsies.
7. **"Do NOT" boxes** at the end of runbooks — the known traps, stated bluntly.
8. **One file, one job**, and files link densely (`[[wikilinks]]` in the vault). Index files
   (00 Home, README maps) say where everything lives; content files never duplicate each other —
   they link.
9. **New files over edits** to Santi's own writing; his creative content (book, About pages,
   lesson content) gets additive help only, and placeholders are marked loudly:
   `<!-- PLACEHOLDER — Santi: replace with your own words -->`.
10. **Tables for enumerable facts, prose for reasoning.** No sprint vocabulary, no corporate
    filler, plain speech, a little personality allowed (📸 = screenshot-worthy win,
    ✅/🟡/⬜ = status, ⚠️ = verified-but-dangerous).
11. **Guides teach on HIS real things**, never on foo/bar abstractions (the GitHub guide uses
    his actual repos; the Dutch examples use his actual life).
12. **Every doc ends with what's next** — a session must never end on a cliff without
    HANDOFF-STATE knowing about it.

## Code & config comments

1. **Comments state constraints, not narration.** Good: `LRS not GRS — the €0 rule` ·
   `never rename: existing data lives under this key`. Bad: "create storage account" above
   a storage account.
2. **Bootstrap order and chicken-and-egg problems get a comment block** at the top of the file
   that suffers from them (see `backend.tf`).
3. **Dead ends are documented in place**, dated: why Azure was dropped lives IN cloudConfig/
   the Azure note, not in chat history.
4. **Slots for future work are physical markers**: `<!-- RUM snippet slot: ... -->` — greppable,
   with a pointer to the doc that explains what goes there.
5. **Pin versions, comment the pin**: `--version 1.59.0  # arm64 = alpha, upgrade deliberately`.
6. **Commit messages**: `area: what and why` in lowercase — `book: fix ch3 typos`,
   `oci-cluster: open udp 7000-8000 (agones)`. History should read like a diary.
7. **Secrets never in code, and the comment says where they DO live**:
   `# token via GITHUB_TOKEN env var`.
8. Generated files say so and name their generator: `search.html` / `book/*.html` headers
   point at the `_build\*.ps1` script — nobody hand-edits generated output.
