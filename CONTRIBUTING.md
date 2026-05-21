# Contributing

This repository follows the Valory Open-Autonomy contribution workflow.
See [open-autonomy/CONTRIBUTING.md](https://github.com/valory-xyz/open-autonomy/blob/main/CONTRIBUTING.md)
for the canonical guide (PR checklist, linter routine, coding style).

## Local workflow

```bash
tomte format-code
tomte check-code
tomte tox -p -e safety -e bandit
tomte tox -e gitleaks
```

If you have modified anything under `packages/`:

```bash
make generators       # regenerate hashes, copyright, abci docstrings
make common-checks-1  # check copyright, hash, packages
make common-checks-2  # check abci docstrings, abciapp specs, handlers
```

## Dependency bumps and ABCI helpers

Use the `open-aea-helpers` plugin (replaces the deleted `scripts/`):

```bash
uv run aea-helpers bump-dependencies --help
uv run aea-helpers check-dependencies --help
uv run aea-helpers check-doc-hashes --help
uv run aea-helpers config-replace --help
```
