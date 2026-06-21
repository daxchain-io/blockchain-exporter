# CLAUDE.md

Guidance for AI assistants (Claude Code and others) working in this repository.

## Status: Deprecated — light maintenance

This project is **deprecated** and superseded by
[daxchain-io/evm-tools](https://github.com/daxchain-io/evm-tools). It is **not
actively developed**: the maintainer lands occasional improvements and cuts a
release now and then, but new functionality generally belongs in evm-tools.

Default to a **maintenance** scope:

- Security fixes and dependency/CVE updates (watch FastAPI, uvicorn, web3, and prometheus-client especially).
- Keeping CI green (lint, tests with coverage ≥85%, config validation).
- Documentation accuracy and small cleanups that keep the repo professional.

Larger improvements or new features happen only when the maintainer explicitly
asks. When unprompted, prefer directing new functionality to
[evm-tools](https://github.com/daxchain-io/evm-tools), and avoid large refactors,
mass reformatting, or new runtime dependencies.

## Orientation

- **Code (source of truth):** start at `src/blockchain_exporter/app.py`
  (`create_app` + lifespan). Background polling lives in `poller/`, RPC and
  metric collection in `rpc.py` / `collectors.py`, Prometheus metrics in
  `metrics.py`, and HTTP endpoints in `api.py` / `health.py`. Config loads via
  `config.py` / `settings.py`.
- **Coverage gaps:** `docs/TEST_COVERAGE_GAPS.md`.

## Design decisions

- **No WebSocket RPC** (deliberate): HTTP RPC is sufficient for polling-based
  collection; WebSocket adds connection-management, reconnection, and fallback
  complexity for marginal benefit at multi-minute poll intervals, and HTTP
  support is more universal across RPC providers.

## Workflow

- Verify changes with `make lint` and `make test` before considering a task
  done. Coverage must stay **≥85%**.
- Cut a release the way `README.md` → "Release Checklist" describes; releases are
  infrequent.
- Keep edits narrowly scoped; preserve existing formatting and import grouping.
  Do not run mass reformatters or reorder imports unless asked.

## Conventions

**Python**

- Import grouping: stdlib, third-party, local — don't introduce new spacing.
- Separate consecutive variable declarations with a blank line (project style).
- Never log secrets (`rpc_url`, API keys); exclude them from structured logging
  extras.
- Keep Prometheus metric label ordering consistent across definitions.
- Alphabetize `__all__`: classes first, then functions, then constants.
- Concise docstrings for modules, classes, and functions.
- No new dependencies without a deliberate decision.

**Tests** (`tests/`)

- Mirror existing fixture patterns (see `tests/conftest.py`); keep runtime fast.
- Use mocked contexts and RPC clients — never hit real endpoints.
- Descriptive test names; keep coverage ≥85%.

**Markdown** — format with `mdformat --wrap=keep` (verify via `make lint-md`).
Keep `README.md` accurate when behavior changes.

**Config** (`config.toml`, `pyproject.toml`, `values.yaml`) — preserve
formatting; use `${VAR_NAME}` interpolation for secrets; keep validation
aggressive; verify with `make validate-config`.

**Helm** (`helm/`) — preserve template formatting; follow existing structure;
verify with `make lint-helm`; document new `values.yaml` options.

**Dockerfile** — follow existing layer ordering; fix Hadolint findings
(`make lint-docker`); keep it production-focused.
