# module github-estate — the SScleves repos as code

Manages the GitHub estate ITSELF via the GitHub provider: repo settings, **Pages configuration**
(so "enable Pages" is never a forgotten click again), descriptions/topics, branch protection on
personal-lab. Content (book text, HTML, notes) stays plain git — this module manages settings.

**Import-first, exactly like work**: the repos already exist, so they are imported (see the
`import` blocks in estate.tf), then `terraform plan` is iterated to zero changes before anything
is ever modified. Never let TF create-or-destroy a repo it didn't import.

Auth: fine-grained PAT (Repository permissions: Administration RW, Pages RW, Contents R)
→ env var `GITHUB_TOKEN` locally / Actions secret. Provider block: `owner = "SScleves"`.

Wire-up: uncomment the module in `envs/lab/main.tf` (a Phase-5-class exercise —
see `vault/tech/GitHub Estate Guide.md` section 6).
