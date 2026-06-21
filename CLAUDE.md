# CLAUDE.md

Guidance for AI assistants (Claude Code and others) working in this repository.

## Status: deprecated, light maintenance

This project is **deprecated**, superseded by
[daxchain-io/evm-tools](https://github.com/daxchain-io/evm-tools), and **not
actively developed**. The maintainer lands occasional improvements and the rare
release; new functionality generally belongs in evm-tools.

Default to a **maintenance** scope — security and dependency/CVE updates (watch
FastAPI, uvicorn, web3, and prometheus-client especially), keeping CI green, doc
accuracy, and small cleanups. Anything larger — new features, big refactors, or
new runtime dependencies — happens only when the maintainer explicitly asks;
when unprompted, point new functionality at evm-tools.

## Orientation

The **code is the source of truth.** Start at `src/blockchain_exporter/app.py`
(`create_app` + lifespan); from there, background polling lives in `poller/`,
RPC and metric collection in `rpc.py` / `collectors.py`, Prometheus metrics in
`metrics.py`, HTTP endpoints in `api.py` / `health.py`, and config loading in
`config.py` / `settings.py`.

One design choice worth preserving: **no WebSocket RPC** — HTTP RPC is enough for
polling-based collection, and WebSocket's connection-management, reconnection,
and fallback complexity buy little at multi-minute poll intervals.

## Working here

- Verify with `make lint` and `make test` before calling a task done; coverage
  must stay **≥85%**.
- Keep edits narrowly scoped; preserve existing formatting and import grouping —
  no mass reformatting or import reordering unless asked.
- Cut releases per `README.md` → "Release Checklist" (they're infrequent).

## Conventions

**Python**

- Import grouping: stdlib, third-party, local.
- Separate consecutive variable declarations with a blank line.
- Never log secrets (`rpc_url`, API keys); keep them out of logging extras.
- Keep Prometheus metric label ordering consistent across definitions.
- Alphabetize `__all__`: classes, then functions, then constants.
- Concise docstrings for modules, classes, and functions.

**Tests** (`tests/`) — mirror the fixtures in `tests/conftest.py`, keep them
fast, and mock contexts/RPC clients (never hit real endpoints).

**Markdown** — format with `mdformat --wrap=keep` (`make lint-md`); keep
`README.md` accurate when behavior changes.

**Config** (`config.toml`, `pyproject.toml`, `values.yaml`) — preserve
formatting; use `${VAR_NAME}` interpolation for secrets; keep validation
aggressive (`make validate-config`).

**Helm** (`helm/`) — preserve template formatting and structure; document new
`values.yaml` options (`make lint-helm`).

**Dockerfile** — follow existing layer ordering; fix Hadolint findings
(`make lint-docker`); keep it production-focused.
