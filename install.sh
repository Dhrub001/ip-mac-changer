#!/bin/bash

# ============================================
# Install IP-MAC-Changer
# Author: Dhrub Raj Giri (DRG)
# ============================================

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; NC='\033[0m'

clear
echo -e "${CYAN}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║         IP-MAC-CHANGER INSTALLATION                       ║"
echo "║         Author: Dhrub Raj Giri (DRG)                     ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

echo -e "${YELLOW}[!] Installing required packages...${NC}"
apt update
apt install tor macchanger isc-dhcp-client curl netcat-openbsd -y

echo -e "${YELLOW}[!] Making scripts executable...${NC}"
chmod +x ip-mac-pro
chmod +x anonymizer.sh
chmod +x stop.sh
chmod +x monitor.sh

echo -e "${GREEN}[✓] Installation complete!${NC}"
echo ""
echo -e "${CYAN}Usage:${NC}"
echo "  sudo ./ip-mac-pro     - Run main tool"
echo "  sudo ./anonymizer.sh  - Run full anonymizer"
echo "  sudo ./stop.sh        - Stop all services"
echo "  ./monitor.sh          - Monitor changes"
echo ""
