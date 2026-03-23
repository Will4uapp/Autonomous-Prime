# Dylan Autonomous Prime — BX6 Solutions

> **Private repo — BX6 Solutions internal use only. Prime branch.**

## What's Included (Prime $499)

Everything in Standard, plus:

| Feature | Standard $250 | Prime $499 |
|---|---|---|
| OpenClaw + Kimi K2.5 | ✓ | ✓ |
| 5 Custom Skills | ✓ | ✓ |
| Branded installer | ✓ | ✓ |
| Auto-restart on crash/reboot | ✗ | ✓ |
| WhatsApp integration | ✗ | ✓ |
| n8n workflow connection | ✗ | ✓ |
| Firewall setup (UFW) | ✗ | ✓ |
| Custom Dylan system prompt | ✗ | ✓ |
| Daily config backup | ✗ | ✓ |
| Log rotation | ✗ | ✓ |
| Secure auth token (auto-generated) | ✗ | ✓ |
| 8 concurrent agents (vs 4) | ✗ | ✓ |

---

## Install (Prime)

SSH into the client's VPS, then run:

```bash
git clone -b prime https://github.com/bx6solutions/dylan-installer
cd dylan-installer
bash install.sh
```

The installer will ask for:
- NVIDIA NIM API key
- Agent name
- Workspace path
- WhatsApp number (optional)
- n8n URL + API key (optional)
- Custom domain (optional)

Takes about 5–8 minutes. Done.

---

## After Install

| Item | Details |
|---|---|
| Control Panel | `http://YOUR-VPS-IP:18789` |
| Auth Token | Printed at end + saved to `/root/.dylan_token` |
| Logs | `tail -f /var/log/dylan.log` |
| Restart | `systemctl restart dylan` |
| Status | `systemctl status dylan` |
| Update | `bash update.sh` |
| Remove | `bash uninstall.sh` |

---

## BX6 Solutions

[bx6solutions.com](https://bx6solutions.com)
