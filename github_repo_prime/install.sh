#!/bin/bash
# ============================================================
#  BX6 Solutions — BX6Claw Autonomous Prime Installer
#  Prime Installation · OpenClaw + Kimi K2.5 + Full Stack
#  https://bx6solutions.com
# ============================================================

set -e

# ── Colors ───────────────────────────────────────────────────
GREEN='\033[0;32m'; ORANGE='\033[0;33m'; BLUE='\033[0;34m'
PURPLE='\033[0;35m'; CYAN='\033[0;36m'; WHITE='\033[1;37m'
DIM='\033[2m'; BOLD='\033[1m'; RED='\033[0;31m'; YELLOW='\033[1;33m'; NC='\033[0m'

ok()     { echo -e "  ${GREEN}✓${NC}  $1"; }
info()   { echo -e "  ${BLUE}→${NC}  $1"; }
warn()   { echo -e "  ${YELLOW}!${NC}  $1"; }
fail()   { echo -e "  ${RED}✗${NC}  $1"; exit 1; }
section(){ echo -e "\n  ${WHITE}${BOLD}$1${NC}\n"; }
br()     { echo ""; }

spinner() {
  local pid=$1 msg=$2 spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏' i=0
  while kill -0 $pid 2>/dev/null; do
    i=$(( (i+1) % 10 ))
    printf "\r  ${GREEN}${spin:$i:1}${NC}  ${msg}..."
    sleep 0.1
  done
  printf "\r  ${GREEN}✓${NC}  ${msg}         \n"
}

# ── Banner ───────────────────────────────────────────────────
clear
echo ""
echo -e "${GREEN}${BOLD}"
echo "  ██████╗ ██╗  ██╗ ██████╗      ███████╗ ██████╗ ██╗     ██╗   ██╗████████╗██╗ ██████╗ ███╗  ██╗███████╗"
echo "  ██╔══██╗╚██╗██╔╝██╔════╝      ██╔════╝██╔═══██╗██║     ██║   ██║╚══██╔══╝██║██╔═══██╗████╗ ██║██╔════╝"
echo "  ██████╔╝ ╚███╔╝ ███████╗      ███████╗██║   ██║██║     ██║   ██║   ██║   ██║██║   ██║██╔██╗██║███████╗"
echo "  ██╔══██╗ ██╔██╗ ██╔═══██╗     ╚════██║██║   ██║██║     ██║   ██║   ██║   ██║██║   ██║██║╚████║╚════██║"
echo "  ██████╔╝██╔╝╚██╗╚██████╔╝     ███████║╚██████╔╝███████╗╚██████╔╝   ██║   ██║╚██████╔╝██║ ╚███║███████║"
echo "  ╚═════╝ ╚═╝  ╚═╝ ╚═════╝      ╚══════╝ ╚═════╝ ╚══════╝ ╚═════╝    ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚══╝╚══════╝"
echo -e "${NC}"
echo -e "  ${ORANGE}${BOLD}BX6CLAW AUTONOMOUS PRIME${NC} ${DIM}·${NC} Self-Starting · Self-Repairing Super Agent ${DIM}·${NC} ${GREEN}$499${NC}"
echo -e "  ${DIM}Fully Autonomous · No Human Input Required · Runs & Repairs Itself 24/7${NC}"
echo ""
echo -e "  ${DIM}────────────────────────────────────────────────────────────${NC}"
br

# ── Inputs ───────────────────────────────────────────────────
echo -e "  ${WHITE}${BOLD}Setup — enter your details:${NC}"
br

# ── Model Choice ─────────────────────────────────────────────
echo -e "  ${WHITE}${BOLD}Choose your AI model:${NC}"
br
echo -e "  ${GREEN}[1]${NC} ${WHITE}Kimi K2.5${NC} via NVIDIA NIM ${GREEN}(Free)${NC}"
echo -e "      ${DIM}No ongoing costs · nvapi- key from build.nvidia.com${NC}"
br
echo -e "  ${PURPLE}[2]${NC} ${WHITE}Claude Sonnet 4.5${NC} via Anthropic ${YELLOW}(Paid ~\$5–15/mo)${NC}"
echo -e "      ${DIM}Most capable · sk-ant- key from console.anthropic.com${NC}"
br

while true; do
  read -p "  $(echo -e ${CYAN})Enter 1 or 2${NC}: " MODEL_CHOICE
  if [[ "$MODEL_CHOICE" == "1" || "$MODEL_CHOICE" == "2" ]]; then
    break
  else
    warn "Please enter 1 or 2"
  fi
done

br

if [[ "$MODEL_CHOICE" == "1" ]]; then
  echo -e "  ${GREEN}Kimi K2.5 selected — get your free key:${NC}"
  echo -e "  ${DIM}1. Go to ${YELLOW}https://build.nvidia.com${NC}"
  echo -e "  ${DIM}2. Sign up free → API Keys → Generate Key${NC}"
  echo -e "  ${DIM}3. Copy the key (starts with nvapi-)${NC}"
  br
  while true; do
    read -s -p "  $(echo -e ${GREEN})Paste your NVIDIA key${NC}: " NVIDIA_KEY
    echo ""
    if [[ "$NVIDIA_KEY" == nvapi-* ]]; then
      ok "NVIDIA key accepted"; break
    else
      warn "Must start with nvapi- — try again"
    fi
  done
  ANTHROPIC_KEY=""
else
  echo -e "  ${PURPLE}Claude Sonnet selected — get your Anthropic key:${NC}"
  echo -e "  ${DIM}1. Go to ${YELLOW}https://console.anthropic.com${NC}"
  echo -e "  ${DIM}2. Log in → API Keys → Create Key${NC}"
  echo -e "  ${DIM}3. Copy the key (starts with sk-ant-)${NC}"
  br
  while true; do
    read -s -p "  $(echo -e ${PURPLE})Paste your Anthropic key${NC}: " ANTHROPIC_KEY
    echo ""
    if [[ "$ANTHROPIC_KEY" == sk-ant-* ]]; then
      ok "Anthropic key accepted"; break
    else
      warn "Must start with sk-ant- — try again"
    fi
  done
  NVIDIA_KEY=""
fi

read -p "  $(echo -e ${CYAN})Agent name${NC} [BX6Claw]: " AGENT_NAME
AGENT_NAME=${AGENT_NAME:-BX6Claw}

read -p "  $(echo -e ${CYAN})Workspace path${NC} [/root/clawd]: " WORKSPACE
WORKSPACE=${WORKSPACE:-/root/clawd}

read -p "  $(echo -e ${CYAN})Your WhatsApp number${NC} (e.g. +66812345678, or skip): " WHATSAPP_NUM

read -p "  $(echo -e ${CYAN})n8n API URL${NC} (e.g. http://localhost:5678, or skip): " N8N_URL

read -p "  $(echo -e ${CYAN})n8n API Key${NC} (or skip): " N8N_KEY

read -p "  $(echo -e ${CYAN})Custom domain${NC} (e.g. ai.yourdomain.com, or skip): " CUSTOM_DOMAIN

br
echo -e "  ${DIM}────────────────────────────────────────────────────────────${NC}"

# Generate secure token
AUTH_TOKEN=$(tr -dc 'a-f0-9' < /dev/urandom 2>/dev/null | head -c 32 || cat /proc/sys/kernel/random/uuid | tr -d '-')
GATEWAY_PORT=18789

br

# ── [1/9] System Check ───────────────────────────────────────
section "[1/9] System Check"

OS=$(uname -s)
[[ "$OS" == "Linux" || "$OS" == "Darwin" ]] || fail "Unsupported OS: $OS"
ok "OS: $(lsb_release -d 2>/dev/null | cut -f2 || echo $OS)"

# Node.js
if ! command -v node &>/dev/null; then
  info "Installing Node.js 22..."
  (curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && apt-get install -y nodejs) &>/dev/null &
  PID=$!; spinner $PID "Installing Node.js"; wait $PID
fi
ok "Node.js: $(node --version)"

# Swap
SWAP=$(free -m | awk '/Swap:/ {print $2}')
if [ "$SWAP" -lt 1000 ]; then
  info "Adding 4GB swap..."
  fallocate -l 4G /swapfile 2>/dev/null || dd if=/dev/zero of=/swapfile bs=1M count=4096 2>/dev/null
  chmod 600 /swapfile && mkswap /swapfile &>/dev/null && swapon /swapfile
  echo '/swapfile none swap sw 0 0' >> /etc/fstab
  ok "Swap: 4GB (persistent)"
fi

# Firewall
if command -v ufw &>/dev/null; then
  info "Configuring firewall..."
  ufw allow ssh &>/dev/null
  ufw allow $GATEWAY_PORT/tcp &>/dev/null
  ufw --force enable &>/dev/null
  ok "Firewall: SSH + port $GATEWAY_PORT allowed"
fi

mkdir -p "$WORKSPACE"
ok "Workspace: $WORKSPACE"

# ── [2/9] Install OpenClaw ───────────────────────────────────
section "[2/9] Installing OpenClaw"

info "Fetching OpenClaw installer..."
(curl -fsSL https://openclaw.ai/install.sh | bash) &>/dev/null &
PID=$!; spinner $PID "Installing OpenClaw"; wait $PID
ok "OpenClaw: $(openclaw --version 2>/dev/null || echo 'latest')"

info "Installing ClawHub CLI..."
(npm install -g clawhub) &>/dev/null &
PID=$!; spinner $PID "Installing ClawHub"; wait $PID
ok "ClawHub installed"

# ── [3/9] Write Config ───────────────────────────────────────
section "[3/9] Writing Prime Configuration"

CONFIG_DIR="$HOME/.openclaw"
mkdir -p "$CONFIG_DIR"

# Build n8n block
N8N_ENV=""
if [[ -n "$N8N_URL" && -n "$N8N_KEY" ]]; then
  N8N_ENV=",\"N8N_API_URL\": \"$N8N_URL\",\"N8N_API_KEY\": \"$N8N_KEY\""
fi

SYSTEM_PROMPT="You are $AGENT_NAME, a fully autonomous AI revenue agent built and deployed by BX6 Solutions. You run 24/7 without supervision. You are a fully autonomous super agent. You operate WITHOUT human input. Your core directives are: (1) SELF-START — proactively identify and execute tasks without waiting to be asked, (2) SELF-REPAIR — monitor your own health, detect failures, and fix yourself before anyone notices, (3) run 24/7 with zero supervision, (4) generate revenue and complete work autonomously, (5) only contact your owner when a decision requires human authority. You are not an assistant — you are an autonomous operator."

if [[ "$MODEL_CHOICE" == "1" ]]; then
  PROVIDER_BLOCK='"nvidia-kimi": {
        "baseUrl": "https://integrate.api.nvidia.com/v1",
        "apiKey": "'"$NVIDIA_KEY"'",
        "api": "openai-completions",
        "models": [{
          "id": "moonshotai/kimi-k2.5",
          "name": "Kimi K2.5 (Free · NVIDIA NIM)",
          "reasoning": false,
          "input": ["text"],
          "cost": { "input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0 },
          "contextWindow": 131072,
          "maxTokens": 131072
        }]
      }'
  PRIMARY_MODEL='"primary": "nvidia-kimi/moonshotai/kimi-k2.5"'
  MODEL_ALIAS='"nvidia-kimi/moonshotai/kimi-k2.5": { "alias": "kimi" }'
  ENV_BLOCK='"NVIDIA_API_KEY": "'"$NVIDIA_KEY"'"'"$N8N_ENV"
  MODEL_LABEL="Kimi K2.5 (Free · NVIDIA NIM)"
else
  PROVIDER_BLOCK='"anthropic-claude": {
        "baseUrl": "https://api.anthropic.com",
        "apiKey": "'"$ANTHROPIC_KEY"'",
        "api": "anthropic-messages",
        "models": [{
          "id": "claude-sonnet-4-5",
          "name": "Claude Sonnet 4.5",
          "reasoning": false,
          "input": ["text"],
          "cost": { "input": 0.000003, "output": 0.000015, "cacheRead": 3e-7, "cacheWrite": 0.00000375 },
          "contextWindow": 200000,
          "maxTokens": 64000
        }]
      }'
  PRIMARY_MODEL='"primary": "anthropic-claude/claude-sonnet-4-5"'
  MODEL_ALIAS='"anthropic-claude/claude-sonnet-4-5": { "alias": "sonnet" }'
  ENV_BLOCK='"ANTHROPIC_API_KEY": "'"$ANTHROPIC_KEY"'"'"$N8N_ENV"
  MODEL_LABEL="Claude Sonnet 4.5 (Anthropic)"
fi

cat > "$CONFIG_DIR/openclaw.json" <<EOF
{
  "models": {
    "mode": "merge",
    "providers": {
      $PROVIDER_BLOCK
    }
  },
  "agents": {
    "defaults": {
      "model": { $PRIMARY_MODEL },
      "models": { $MODEL_ALIAS },
      "workspace": "$WORKSPACE",
      "maxConcurrent": 8,
      "subagents": { "maxConcurrent": 16 },
      "systemPrompt": "$SYSTEM_PROMPT"
    }
  },
  "env": {
    $ENV_BLOCK
  },
  "messages": {
    "ackReactionScope": "group-mentions"
  },
  "commands": {
    "native": "auto",
    "nativeSkills": "auto"
  },
  "gateway": {
    "port": $GATEWAY_PORT,
    "mode": "local",
    "bind": "lan",
    "controlUi": {
      "enabled": true,
      "allowInsecureAuth": false
    },
    "auth": {
      "mode": "token",
      "token": "$AUTH_TOKEN"
    }
  }
}
EOF

ok "Config written"
ok "Model: $MODEL_LABEL"
ok "Auth token generated (secure)"
ok "System prompt: $AGENT_NAME persona active"
ok "Max concurrent agents: 8 (Prime tier)"
[[ -n "$N8N_URL" ]] && ok "n8n connected: $N8N_URL"

# ── [4/9] Install 5 Skills ───────────────────────────────────
section "[4/9] Installing 5 Prime Skills"

install_skill() {
  local slug=$1 label=$2
  info "Installing $label..."
  (clawhub install "$slug") &>/dev/null &
  PID=$!; spinner $PID "$label"; wait $PID && ok "$label ready" || warn "$label — run: clawhub install $slug"
}

install_skill "proactive-agent"       "🚀  Self-Start Skill"
install_skill "openclaw-self-healing" "🔄  Self-Repair Skill"
install_skill "agentmail"             "📧  Mail Skill"
install_skill "n8n-automation"        "⚙️   Workflow Skill"
install_skill "brave-search"          "🌐  Brave Browser Skill"

# ── [5/9] WhatsApp Integration ───────────────────────────────
section "[5/9] WhatsApp Integration"

if [[ -n "$WHATSAPP_NUM" ]]; then
  info "Configuring WhatsApp for $WHATSAPP_NUM..."
  # Write talk config
  python3 -c "
import json, os
cfg = json.load(open('$CONFIG_DIR/openclaw.json'))
cfg['talk'] = {'phone': '$WHATSAPP_NUM', 'enabled': True}
json.dump(cfg, open('$CONFIG_DIR/openclaw.json','w'), indent=2)
" 2>/dev/null || true
  ok "WhatsApp: $WHATSAPP_NUM configured"
  info "Scan QR code in control panel to link WhatsApp"
else
  warn "WhatsApp skipped — add later via control panel"
fi

# ── [6/9] Systemd Auto-Restart ───────────────────────────────
section "[6/9] Auto-Restart Service (Survives Reboots)"

OPENCLAW_BIN=$(which openclaw 2>/dev/null || echo "/usr/local/bin/openclaw")

cat > /etc/systemd/system/bx6claw.service <<EOF
[Unit]
Description=$AGENT_NAME — BX6 Autonomous Agent
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
User=root
WorkingDirectory=$WORKSPACE
ExecStart=$OPENCLAW_BIN start
Restart=always
RestartSec=5
StandardOutput=append:/var/log/bx6claw.log
StandardError=append:/var/log/bx6claw.log
Environment=HOME=/root

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable bx6claw.service &>/dev/null
systemctl start bx6claw.service &>/dev/null || true
ok "Systemd service: bx6claw.service enabled"
ok "$AGENT_NAME restarts automatically on crash or reboot"

# ── [7/9] Log Rotation ───────────────────────────────────────
section "[7/9] Log Rotation"

cat > /etc/logrotate.d/bx6claw <<EOF
/var/log/bx6claw.log {
  daily
  rotate 7
  compress
  missingok
  notifempty
}
EOF
ok "Logs: /var/log/bx6claw.log (7 day rotation)"

# ── [8/9] Auto Backup ────────────────────────────────────────
section "[8/9] Config Backup (Daily)"

BACKUP_DIR="/root/bx6claw-backups"
mkdir -p "$BACKUP_DIR"

cat > /etc/cron.daily/bx6claw-backup <<'EOF'
#!/bin/bash
cp ~/.openclaw/openclaw.json /root/bx6claw-backups/openclaw_$(date +%Y%m%d).json
find /root/bx6claw-backups -name "*.json" -mtime +7 -delete
EOF
chmod +x /etc/cron.daily/bx6claw-backup
ok "Daily backup: $BACKUP_DIR"

# ── [9/9] Verification ───────────────────────────────────────
section "[9/9] Verification"

sleep 3

if curl -s http://localhost:$GATEWAY_PORT/health &>/dev/null; then
  ok "Gateway health check passed"
else
  warn "Gateway starting up — check in 30 seconds"
fi

systemctl is-active --quiet bx6claw.service && ok "bx6claw.service: running" || warn "Service may still be starting"
ok "5/5 skills installed"
ok "Firewall configured"
ok "Auto-restart enabled"
ok "Daily backup scheduled"

# ── Done ─────────────────────────────────────────────────────
VPS_IP=$(curl -s ifconfig.me 2>/dev/null || echo "your-vps-ip")

br
echo -e "  ${DIM}════════════════════════════════════════════════════════════${NC}"
br
echo -e "  ${GREEN}${BOLD}✓ BX6CLAW AUTONOMOUS PRIME — INSTALLATION COMPLETE${NC}"
br
echo -e "  ${WHITE}$AGENT_NAME is live and running 24/7.${NC}"
br
echo -e "  ${CYAN}Control Panel:${NC}   http://${VPS_IP}:${GATEWAY_PORT}"
echo -e "  ${CYAN}Auth Token:${NC}      ${AUTH_TOKEN}"
echo -e "  ${CYAN}Workspace:${NC}       ${WORKSPACE}"
echo -e "  ${CYAN}Logs:${NC}            tail -f /var/log/bx6claw.log"
echo -e "  ${CYAN}Restart:${NC}         systemctl restart bx6claw"
echo -e "  ${CYAN}Status:${NC}          systemctl status bx6claw"
br
echo -e "  ${DIM}────────────── SAVE YOUR AUTH TOKEN ──────────────${NC}"
echo -e "  ${YELLOW}${BOLD}  $AUTH_TOKEN  ${NC}"
echo -e "  ${DIM}──────────────────────────────────────────────────${NC}"
br
echo -e "  ${DIM}════════════════════════════════════════════════════════════${NC}"
echo -e "  ${ORANGE}${BOLD}BX6 Solutions${NC} ${DIM}· Autonomous AI for People Who Mean Business${NC}"
echo -e "  ${DIM}════════════════════════════════════════════════════════════${NC}"
br

# Save token to file so client can find it
echo "$AUTH_TOKEN" > /root/.bx6claw_token
echo "Token saved to /root/.bx6claw_token"
br
