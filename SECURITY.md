# Security

Orphan runs on boards on your own network. Its web pages (the board page, VIZOR, the cores' pages) have no login,
and VIZOR has a root shell, by design: **keep the board on a network you trust and never expose it to the
internet**. Change the root password (`passwd`). VIZOR's shell and X desktop can be switched off in
`/etc/orphan/vizor.json`.

## Reporting a problem

Please report security problems privately: on GitHub, **Security**, **Report a vulnerability**
(https://github.com/revjmoney/orphan/security/advisories/new). Do not open a public issue for them.
You'll get an answer as soon as possible; fixes ship in the next release and through `orphan-update`.

What's in place on this repo: Dependabot alerts and security updates, secret scanning with push protection,
CodeQL code scanning, and CI checks (including a guard against private data) on every push.

[Rev. J. Money - 2026] · by JMSCNC, makers of RotatoCAM
