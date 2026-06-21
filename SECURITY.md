# Security Policy

> **This project is deprecated** and superseded by
> [daxchain-io/evm-tools](https://github.com/daxchain-io/evm-tools). It receives
> light maintenance — primarily security and dependency updates — so security
> reports are still welcome, though responses may be slower than for an actively
> developed project. For new deployments, prefer
> [evm-tools](https://github.com/daxchain-io/evm-tools).

## Supported versions

Only the latest release receives security fixes. Older tags are not patched.

| Version        | Supported          |
| -------------- | ------------------ |
| Latest release | :white_check_mark: |
| Older releases | :x:                |

## Reporting a vulnerability

Please report security issues **privately** — do not open a public issue.

- Use GitHub's private vulnerability reporting: go to the
  [**Security** tab](https://github.com/daxchain-io/blockchain-exporter/security)
  → **Report a vulnerability**. This opens a private advisory visible only to the
  maintainers.

When reporting, please include:

- A description of the issue and its impact.
- Steps to reproduce (a minimal config or request is ideal).
- Affected version(s) and any relevant environment details.

We aim to acknowledge reports within a reasonable window given the project's
maintenance status, and will coordinate a fix or mitigation for confirmed issues
in the latest release. Please allow time for a fix before any public disclosure.

## Scope notes

- Never include secrets (RPC URLs, API keys) in reports or reproductions — this
  exporter is built to keep them out of logs; please do the same.
- Dependency vulnerabilities are tracked via Dependabot (see
  `.github/dependabot.yml`); you may report them here as well if you believe one
  is being exploited or is otherwise urgent.
