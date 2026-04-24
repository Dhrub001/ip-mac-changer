#!/bin/bash

# ============================================
# IP & MAC Changer v1.0
# Author: Dhrub Raj Giri
# GitHub: @Dhrub001
# Description: Advanced IP & MAC address changer using Tor network
# ============================================

# Color codes for movie-style output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Configuration file
CONFIG_FILE="/etc/ip-mac-changer/config.conf"
LOG_FILE="/var/log/ip-mac-changer.log"

# Default values (will be overridden by config if exists)
CHANGE_INTERVAL=60
NETWORK_INTERFACE="auto"
RESTORE_MAC=true
ENABLE_LOGGING=true
TOR_SOCKS_PORT=9050
TOR_CONTROL_PORT=9051

# Function to display cool banner
display_banner() {
    clear
    echo -e "${RED}"
    cat << "EOF"
    ╔═══════════════════════════════════════════════════════════╗
    ║                                                           ║
    ║   ██▓ ██▓███   ▄▄▄      ▄▄▄█████▓ ▄████▄   ██░ ██ ▄▄▄     ║
    ║  ▓██▒▓██░  ██▒▒████▄    ▓  ██▒ ▓▒▒██▀ ▀█  ▓██░ ██▒████▄   ║
    ║  ▒██▒▓██░ ██▓▒▒██  ▀█▄  ▒ ▓██░ ▒░▒▓█    ▄ ▒██▀▀██░▒██  ▀█▄ ║
    ║  ░██░▒██▄█▓▒ ▒░██▄▄▄▄██ ░ ▓██▓ ░ ▒▓▓▄ ▄██▒░▓█ ░██ ░██▄▄▄▄██║
    ║  ░██░▒██▒ ░  ░ ▓█   ▓██▒  ▒██▒ ░ ▒ ▓███▀ ░░▓█▒░██▓ ▓█   ▓██║
    ║  ░▓  ▒▓▒░ ░  ░ ▒▒   ▓▒█░  ▒ ░░   ░ ░▒ ▒  ░ ▒ ░░▒░▒ ▒▒   ▓▒█║
    ║   ▒ ░░▒ ░       ▒   ▒▒ ░    ░      ░  ▒    ▒ ░▒░ ░  ▒   ▒▒ ░║
    ║   ▒ ░░░         ░   ▒     ░      ░         ░  ░░ ░  ░   ▒   ║
    ║   ░                 ░  ░            ░ ░       ░  ░       ░ 3║
    ║                                                           ║
    ║          IP & MAC ADDRESS CHANGER v1.0                    ║
    ║           Author: Dhrub Raj Giri                          ║
    ║           "HACK THE PLANET!"                               ║
    ╚═══════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    sleep 2
}

# Function to log messages
log_message() {
    local message="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    if [[ "$ENABLE_LOGGING" == true ]]; then
        echo "[$timestamp] $message" | tee -a "$LOG_FILE"
    fi
    
    echo -e "$message"
}

# Function to load configuration
load_config() {
    if [[ -f "$CONFIG_FILE" ]]; then
        source "$CONFIG_FILE"
        log_message "${GREEN}[✓] Configuration loaded from $CONFIG_FILE${NC}"
    else
        log_message "${YELLOW}[!] Config file not found, using defaults${NC}"
        
        # Create config directory if it doesn't exist
        sudo mkdir -p /etc/ip-mac-changer
        
        # Create default config
        cat << EOF | sudo tee "$CONFIG_FILE" > /dev/null
# IP & MAC Changer Configuration
CHANGE_INTERVAL=$CHANGE_INTERVAL
NETWORK_INTERFACE=$NETWORK_INTERFACE
RESTORE_MAC=$RESTORE_MAC
ENABLE_LOGGING=$ENABLE_LOGGING
TOR_SOCKS_PORT=$TOR_SOCKS_PORT
TOR_CONTROL_PORT=$TOR_CONTROL_PORT
EOF
        log_message "${GREEN}[✓] Default config created at $CONFIG_FILE${NC}"
    fi
}

# Function to get default network interface
get_interface() {
    if [[ "$NETWORK_INTERFACE" == "auto" ]]; then
        # Try to find the default interface for internet connection
        local interface=$(ip route | grep default | awk '{print $5}' | head -1)
        
        if [[ -z "$interface" ]]; then
            # Fallback: get first non-loopback interface
            interface=$(ip link show | grep -v lo | grep -v veth | grep -v docker | grep "state UP" | head -1 | cut -d: -f2 | xargs)
        fi
        
        if [[ -z "$interface" ]]; then
            log_message "${RED}[✗] Could not detect network interface${NC}"
            exit 1
        fi
        
        echo "$interface"
    else
        echo "$NETWORK_INTERFACE"
    fi
}

# Function to get current IP address
get_current_ip() {
    local ip=""
    
    # Try multiple methods to get current IP
    if command -v curl &> /dev/null; then
        ip=$(curl --socks5-hostname localhost:$TOR_SOCKS_PORT -s --max-time 5 https://api.ipify.org 2>/dev/null)
    fi
    
    if [[ -z "$ip" ]] && command -v wget &> /dev/null; then
        ip=$(wget -q -O - --timeout=5 https://api.ipify.org 2>/dev/null)
    fi
    
    if [[ -z "$ip" ]]; then
        # Fallback to local IP
        ip=$(ip -4 addr show $(get_interface) | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -1)
    fi
    
    echo "$ip"
}

# Function to get current MAC address
get_current_mac() {
    local interface=$(get_interface)
    local mac=$(cat /sys/class/net/$interface/address 2>/dev/null)
    echo "$mac"
}

# Function to generate random MAC address
generate_random_mac() {
    # Generate a random locally administered MAC address (starts with 02, 06, 0A, 0E)
    local hexchars="0123456789ABCDEF"
    local mac=""
    
    # First octet: locally administered, unicast (02, 06, 0A, 0E)
    local first_octet_options=(02 06 0A 0E)
    mac="${first_octet_options[$RANDOM % 4]}"
    
    # Generate remaining 5 octets
    for i in {1..5}; do
        mac="$mac:"
        for j in {1..2}; do
            mac="$mac${hexchars:$((RANDOM % 16)):1}"
        done
    done
    
    echo "$mac"
}

# Function to change MAC address
change_mac() {
    local interface=$1
    local new_mac=$2
    local original_mac=$(get_current_mac)
    
    log_message "${CYAN}[→] Changing MAC address on $interface...${NC}"
    log_message "${YELLOW}[!] Original MAC: $original_mac${NC}"
    log_message "${YELLOW}[!] New MAC: $new_mac${NC}"
    
    # Bring interface down
    sudo ip link set dev $interface down
    
    # Change MAC address
    sudo ip link set dev $interface address $new_mac
    
    # Bring interface up
    sudo ip link set dev $interface up
    
    # Verify change
    local current_mac=$(get_current_mac)
    
    if [[ "$current_mac" == "$new_mac" ]]; then
        log_message "${GREEN}[✓] MAC address changed successfully!${NC}"
        return 0
    else
        log_message "${RED}[✗] Failed to change MAC address${NC}"
        return 1
    fi
}

# Function to change IP address using Tor
change_ip() {
    log_message "${CYAN}[→] Changing IP address via Tor network...${NC}"
    
    # Check if Tor is running
    if ! systemctl is-active --quiet tor; then
        log_message "${YELLOW}[!] Tor is not running, starting Tor...${NC}"
        sudo systemctl start tor
        sleep 5
    fi
    
    # Request new identity from Tor
    if command -v tor &> /dev/null; then
        # Using tor command to request new identity
        echo -e 'AUTHENTICATE ""\r\nSIGNAL NEWNYM\r\nQUIT' | nc -q 2 127.0.0.1 $TOR_CONTROL_PORT 2>/dev/null
        
        if [[ $? -eq 0 ]]; then
            log_message "${GREEN}[✓] New Tor identity requested!${NC}"
        else
            log_message "${YELLOW}[!] Could not connect to Tor control port, restarting Tor...${NC}"
            sudo systemctl restart tor
            sleep 5
        fi
    else
        # Alternative: restart Tor service
        sudo systemctl restart tor
        sleep 5
    fi
    
    # Wait for new IP to be established
    sleep 3
    
    # Get new IP
    local new_ip=$(get_current_ip)
    
    if [[ -n "$new_ip" ]]; then
        log_message "${GREEN}[✓] New IP address: $new_ip${NC}"
        return 0
    else
        log_message "${RED}[✗] Failed to get new IP address${NC}"
        return 1
    fi
}

# Function to test connectivity
test_connectivity() {
    log_message "${CYAN}[→] Testing internet connectivity...${NC}"
    
    # Test via Tor
    if curl --socks5-hostname localhost:$TOR_SOCKS_PORT -s --max-time 5 https://www.google.com > /dev/null 2>&1; then
        log_message "${GREEN}[✓] Internet connection working via Tor${NC}"
        return 0
    else
        log_message "${RED}[✗] No internet connection via Tor${NC}"
        return 1
    fi
}

# Function to check location (IP geolocation)
check_location() {
    log_message "${CYAN}[→] Fetching location information...${NC}"
    
    local location_data=$(curl --socks5-hostname localhost:$TOR_SOCKS_PORT -s --max-time 10 "http://ip-api.com/json/" 2>/dev/null)
    
    if [[ -n "$location_data" ]]; then
        local country=$(echo "$location_data" | grep -o '"country":"[^"]*"' | cut -d'"' -f4)
        local city=$(echo "$location_data" | grep -o '"city":"[^"]*"' | cut -d'"' -f4)
        local isp=$(echo "$location_data" | grep -o '"isp":"[^"]*"' | cut -d'"' -f4)
        
        log_message "${GREEN}[✓] Location: $city, $country${NC}"
        log_message "${GREEN}[✓] ISP: $isp${NC}"
    else
        log_message "${YELLOW}[!] Could not fetch location data${NC}"
    fi
}

# Function to save original MAC address
save_original_mac() {
    local interface=$1
    local original_mac=$(get_current_mac)
    
    echo "$original_mac" | sudo tee /etc/ip-mac-changer/original_mac > /dev/null
    log_message "${BLUE}[i] Original MAC saved: $original_mac${NC}"
}

# Function to restore original MAC address
restore_original_mac() {
    if [[ "$RESTORE_MAC" == true ]]; then
        local interface=$(get_interface)
        local original_mac_file="/etc/ip-mac-changer/original_mac"
        
        if [[ -f "$original_mac_file" ]]; then
            local original_mac=$(cat "$original_mac_file")
            log_message "${YELLOW}[!] Restoring original MAC address: $original_mac${NC}"
            
            sudo ip link set dev $interface down
            sudo ip link set dev $interface address $original_mac
            sudo ip link set dev $interface up
            
            log_message "${GREEN}[✓] Original MAC restored${NC}"
        else
            log_message "${YELLOW}[!] No original MAC saved, skipping restore${NC}"
        fi
    fi
}

# Function to handle script termination safely
cleanup() {
    echo -e "\n${YELLOW}[!] Received termination signal...${NC}"
    restore_original_mac
    log_message "${RED}[✗] IP & MAC Changer stopped${NC}"
    exit 0
}

# Function to display current status
display_status() {
    local current_ip=$(get_current_ip)
    local current_mac=$(get_current_mac)
    local interface=$(get_interface)
    
    echo -e "\n${BLUE}════════════════════════════════════════════${NC}"
    echo -e "${GREEN}[✓] Current Status${NC}"
    echo -e "${BLUE}════════════════════════════════════════════${NC}"
    echo -e "${CYAN}Interface:${NC} $interface"
    echo -e "${CYAN}MAC Address:${NC} $current_mac"
    echo -e "${CYAN}IP Address:${NC} $current_ip"
    echo -e "${BLUE}════════════════════════════════════════════${NC}\n"
}

# Main execution loop
main() {
    # Trap termination signals
    trap cleanup SIGINT SIGTERM SIGHUP EXIT
    
    # Load configuration
    load_config
    
    # Display cool banner
    display_banner
    
    # Get network interface
    INTERFACE=$(get_interface)
    log_message "${GREEN}[✓] Using network interface: $INTERFACE${NC}"
    
    # Save original MAC for later restore
    save_original_mac "$INTERFACE"
    
    # Check if Tor is installed
    if ! command -v tor &> /dev/null; then
        log_message "${RED}[✗] Tor is not installed!${NC}"
        log_message "${YELLOW}[!] Please install Tor: sudo apt install tor (Debian/Ubuntu)${NC}"
        exit 1
    fi
    
    # Start Tor if not running
    if ! systemctl is-active --quiet tor; then
        log_message "${YELLOW}[!] Starting Tor service...${NC}"
        sudo systemctl start tor
        sleep 5
    fi
    
    # Test initial connectivity
    test_connectivity
    
    # Main loop
    local counter=0
    while true; do
        counter=$((counter + 1))
        
        echo -e "\n${PURPLE}════════════════════════════════════════════${NC}"
        echo -e "${BOLD}${CYAN}[🌀] Change Cycle #$counter${NC}"
        echo -e "${PURPLE}════════════════════════════════════════════${NC}"
        
        # Generate new MAC
        NEW_MAC=$(generate_random_mac)
        
        # Change MAC address
        if change_mac "$INTERFACE" "$NEW_MAC"; then
            log_message "${GREEN}[✓] MAC spoofed successfully!${NC}"
        else
            log_message "${RED}[✗] MAC change failed!${NC}"
        fi
        
        # Small delay between MAC and IP change
        sleep 2
        
        # Change IP address via Tor
        if change_ip; then
            log_message "${GREEN}[✓] IP address changed!${NC}"
            test_connectivity
            check_location
        else
            log_message "${RED}[✗] IP change failed!${NC}"
        fi
        
        # Display current status
        display_status
        
        # Wait for next interval
        log_message "${YELLOW}[⏰] Next change in $CHANGE_INTERVAL seconds...${NC}"
        sleep $CHANGE_INTERVAL
    done
}

# Start the script
main