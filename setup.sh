#!/bin/bash

# ============================================
# IP & MAC Changer Setup Script
# Author: Dhrub Raj Giri
# GitHub: @Dhrub001
# ============================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${BLUE}"
cat << "EOF"
    ╔═══════════════════════════════════════════╗
    ║     IP & MAC Changer - Setup Wizard       ║
    ║        One-click installation              ║
    ╚═══════════════════════════════════════════╝
EOF
echo -e "${NC}"

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    echo -e "${RED}[!] Please don't run this script as root directly${NC}"
    echo -e "${YELLOW}[!] Run as normal user (will use sudo when needed)${NC}"
    exit 1
fi

echo -e "${GREEN}[✓] Checking system requirements...${NC}"

# Detect distribution
if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    OS=$ID
    VER=$VERSION_ID
    echo -e "${GREEN}[✓] Detected: $NAME $VERSION${NC}"
else
    echo -e "${YELLOW}[!] Could not detect distribution${NC}"
    OS="unknown"
fi

# Install dependencies based on distribution
echo -e "\n${CYAN}[→] Installing required packages...${NC}"

install_packages() {
    case $OS in
        ubuntu|debian|kali|parrot)
            sudo apt update
            sudo apt install -y tor curl netcat-openbsd iproute2 wget
            ;;
        arch|manjaro)
            sudo pacman -Syu --noconfirm tor curl gnu-netcat iproute2 wget
            ;;
        fedora)
            sudo dnf install -y tor curl nmap-ncat iproute wget
            ;;
        opensuse|suse)
            sudo zypper install -y tor curl netcat iproute2 wget
            ;;
        *)
            echo -e "${YELLOW}[!] Unknown distribution. Please install manually:${NC}"
            echo -e "    tor, curl, netcat, iproute2, wget"
            ;;
    esac
}

install_packages

# Ask for change interval
echo -e "\n${CYAN}[→] Configuration Setup${NC}"
echo -e "${YELLOW}How often should the IP/MAC change? (in seconds)${NC}"
echo -e "  10  - Movie mode (very frequent)"
echo -e "  30  - Paranoid mode"
echo -e "  60  - Normal mode (default)"
echo -e "  300 - Stealth mode"
read -p "Enter interval [60]: " CHANGE_INTERVAL
CHANGE_INTERVAL=${CHANGE_INTERVAL:-60}

# Ask for network interface
echo -e "\n${CYAN}[→] Network Interface${NC}"
echo -e "${YELLOW}Available interfaces:${NC}"
ip link show | grep -v lo | grep -v veth | grep "state UP" || ip link show | grep -v lo | head -5
read -p "Enter interface name [auto]: " NETWORK_INTERFACE
NETWORK_INTERFACE=${NETWORK_INTERFACE:-auto}

# Ask about MAC restore
echo -e "\n${CYAN}[→] MAC Address Settings${NC}"
read -p "Restore original MAC on exit? (y/n) [y]: " RESTORE_MAC_CHOICE
if [[ "$RESTORE_MAC_CHOICE" == "n" ]]; then
    RESTORE_MAC=false
else
    RESTORE_MAC=true
fi

# Create directories
echo -e "\n${CYAN}[→] Creating directories...${NC}"
sudo mkdir -p /etc/ip-mac-changer
sudo mkdir -p /var/log

# Copy main script
echo -e "${CYAN}[→] Installing main script...${NC}"
sudo cp ip-mac-changer.sh /usr/local/bin/ip-mac-changer
sudo chmod +x /usr/local/bin/ip-mac-changer

# Create configuration file
echo -e "${CYAN}[→] Creating configuration...${NC}"
cat << EOF | sudo tee /etc/ip-mac-changer/config.conf > /dev/null
# IP & MAC Changer Configuration
CHANGE_INTERVAL=$CHANGE_INTERVAL
NETWORK_INTERFACE=$NETWORK_INTERFACE
RESTORE_MAC=$RESTORE_MAC
ENABLE_LOGGING=true
TOR_SOCKS_PORT=9050
TOR_CONTROL_PORT=9051
EOF

# Create systemd service file
echo -e "${CYAN}[→] Creating systemd service...${NC}"
cat << EOF | sudo tee /etc/systemd/system/ip-mac-changer.service > /dev/null
[Unit]
Description=IP & MAC Changer Service
After=network.target tor.service
Wants=tor.service

[Service]
Type=simple
User=root
ExecStart=/usr/local/bin/ip-mac-changer
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

# Configure Tor
echo -e "${CYAN}[→] Configuring Tor for IP rotation...${NC}"
sudo systemctl enable tor 2>/dev/null
sudo systemctl start tor

# Configure Tor control port for NEWNYM signal
sudo bash -c 'cat >> /etc/tor/torrc << EOF

# IP & MAC Changer configuration
ControlPort 9051
CookieAuthentication 0
EOF'

# Restart Tor with new configuration
sudo systemctl restart tor
sleep 3

# Enable and start the service
echo -e "${CYAN}[→] Enabling service...${NC}"
sudo systemctl daemon-reload
sudo systemctl enable ip-mac-changer.service
sudo systemctl start ip-mac-changer.service

# Check service status
echo -e "\n${CYAN}[→] Checking service status...${NC}"
sleep 2
sudo systemctl status ip-mac-changer.service --no-pager

echo -e "\n${GREEN}════════════════════════════════════════════${NC}"
echo -e "${GREEN}[✓] Installation Complete!${NC}"
echo -e "${GREEN}════════════════════════════════════════════${NC}"
echo -e ""
echo -e "${CYAN}Service Information:${NC}"
echo -e "  • Status: sudo systemctl status ip-mac-changer"
echo -e "  • Start:  sudo systemctl start ip-mac-changer"
echo -e "  • Stop:   sudo systemctl stop ip-mac-changer"
echo -e "  • Logs:   sudo journalctl -u ip-mac-changer -f"
echo -e ""
echo -e "${CYAN}Configuration:${NC}"
echo -e "  • Config file: /etc/ip-mac-changer/config.conf"
echo -e "  • Log file:    /var/log/ip-mac-changer.log"
echo -e ""
echo -e "${YELLOW}To change interval, edit config.conf and restart service${NC}"
echo -e ""
echo -e "${GREEN}Service is running in background! Your IP/MAC will change every ${CHANGE_INTERVAL} seconds${NC}"
echo -e "${BLUE}Visit: https://github.com/Dhrub001/ip-mac-changer${NC}"