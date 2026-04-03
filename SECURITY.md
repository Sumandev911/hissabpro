# Security Policy

## Supported Versions

The following versions of HisaabPro are currently receiving security updates:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |

## Reporting a Vulnerability

We take security vulnerabilities seriously. If you discover a security issue in HisaabPro, please report it responsibly by following these guidelines:

### How to Report

**Please do not report security vulnerabilities through public GitHub issues.**

Instead, report security vulnerabilities by opening a [GitHub Security Advisory](https://github.com/Sumandev911/hissabpro/security/advisories/new) in this repository. This ensures the report is handled privately until a fix is released.

Alternatively, you may contact the maintainer directly via GitHub: [@Sumandev911](https://github.com/Sumandev911).

### What to Include

Please include as much of the following information as possible to help us understand and address the issue quickly:

- **Type of vulnerability** (e.g., data exposure, injection, authentication bypass)
- **Location** – the file(s) and line number(s) where the vulnerability exists
- **Reproduction steps** – a minimal, step-by-step description of how to reproduce the issue
- **Proof-of-concept or exploit code** (if available)
- **Potential impact** – describe what an attacker could achieve by exploiting this vulnerability

### Response Timeline

- **Acknowledgement**: We aim to acknowledge receipt of your report within **48 hours**.
- **Initial assessment**: We will provide an initial assessment within **5 business days**.
- **Fix & disclosure**: We aim to release a fix within **30 days** of confirming the vulnerability. We will coordinate with you on the public disclosure timeline.

### Safe Harbour

We will not take legal action against researchers who discover and responsibly disclose security vulnerabilities in accordance with this policy.

## Security Best Practices for Contributors

- Keep all dependencies up to date (Dependabot is configured to open PRs automatically).
- Do not hard-code secrets, API keys, or credentials in the source code.
- Review the [Flutter security best practices](https://docs.flutter.dev/security) when contributing.
