#!/bin/bash
# BX6 Solutions — Dylan Uninstaller

GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'; NC='\033[0m'; BOLD='\033[1m'

echo ""
echo -e "${RED}${BOLD}BX6 Solutions — Dylan Uninstaller${NC}"
echo -e "${YELLOW}This will remove OpenClaw and all 5 skills.${NC}"
echo ""
read -p "  Are you sure? (yes/no): " CONFIRM
if [[ "$CONFIRM" != "yes" ]]; then echo "Cancelled."; exit 0; fi

echo ""
echo -e "  Stopping OpenClaw daemon..."
openclaw stop 2>/dev/null || true

echo -e "  Removing skills..."
clawhub uninstall proactive-agent 2>/dev/null || true
clawhub uninstall openclaw-self-healing 2>/dev/null || true
clawhub uninstall agentmail 2>/dev/null || true
clawhub uninstall n8n-automation 2>/dev/null || true
clawhub uninstall brave-search 2>/dev/null || true

echo -e "  Removing OpenClaw..."
npm uninstall -g openclaw 2>/dev/null || true
npm uninstall -g clawhub 2>/dev/null || true

echo -e "  Removing config..."
rm -rf ~/.openclaw

echo ""
echo -e "  ${GREEN}✓ Dylan has been removed.${NC}"
echo -e "  Contact bx6solutions.com to reinstall."
echo ""
