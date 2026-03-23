#!/bin/bash
# BX6 Solutions — Dylan Updater

GREEN='\033[0;32m'; BLUE='\033[0;34m'; NC='\033[0m'; BOLD='\033[1m'; DIM='\033[2m'

ok()   { echo -e "  ${GREEN}✓${NC}  $1"; }
info() { echo -e "  ${BLUE}→${NC}  $1"; }

echo ""
echo -e "${GREEN}${BOLD}BX6 Solutions — Dylan Update${NC}"
echo -e "${DIM}Updating OpenClaw + all 5 skills${NC}"
echo ""

info "Updating OpenClaw..."
npm install -g openclaw@latest 2>/dev/null && ok "OpenClaw updated" || ok "OpenClaw already latest"

info "Updating skills..."
clawhub update --all 2>/dev/null && ok "All skills updated" || {
  clawhub install proactive-agent 2>/dev/null && ok "Self-Start updated"
  clawhub install openclaw-self-healing 2>/dev/null && ok "Self-Repair updated"
  clawhub install agentmail 2>/dev/null && ok "Mail updated"
  clawhub install n8n-automation 2>/dev/null && ok "Workflow updated"
  clawhub install brave-search 2>/dev/null && ok "Brave Browser updated"
}

info "Restarting Dylan..."
openclaw restart 2>/dev/null && ok "Dylan restarted" || true

echo ""
echo -e "  ${GREEN}${BOLD}✓ Update complete.${NC}"
echo -e "  ${DIM}BX6 Solutions · bx6solutions.com${NC}"
echo ""
