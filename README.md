# 🕵️ IP & MAC Changer

[![Version](https://img.shields.io/badge/version-1.0-blue.svg)](https://github.com/Dhrub001/ip-mac-changer)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Linux-lightgrey.svg)](https://www.linux.org)
[![Shell](https://img.shields.io/badge/shell-bash-red.svg)](https://www.gnu.org/software/bash/)

> **"HACK THE PLANET!"** 🌍  
> Automate MAC address spoofing and DHCP IP renewal at custom intervals.

---
## 📖 The Story

Growing up watching hacker movies like *Mr. Robot*, *Whoami*, and *Sneakers*, I was fascinated by how attackers could instantly change their digital identity and disappear.

That iconic line — **"I'm in."** — inspired me to explore networking and cybersecurity more deeply.

After weeks of hands-on practice, debugging, and learning from seniors (with some AI assistance), I built this tool to simulate "movie-style" identity switching in a real Linux environment.

⚠️ This is **not true anonymity** — it is a **learning and experimentation tool**.
---

## 🎯 Purpose

| Purpose | Description |
|---------|-------------|
| 🎓 Learning | Understand MAC spoofing & DHCP |
| 🔬 Testing | Observe network behavior |
| 🎬 Simulation | Experience hacker-style operations |
| 🛡️ Practice | Basic privacy experimentation |
---
---
## ⚠️ Scope & Limitations

### ✔ What it DOES
- Changes MAC address (Layer 2 identity)
- Renews IP via DHCP
- Automates repeated execution

### ✖ What it DOES NOT DO
- Change public IP
- Provide anonymity
- Bypass ISP tracking
- Replace VPN / Tor
---

## ⚙️ How It Works

### Simple Explanation

| Identifier | Meaning | Tool Action |
|------------|---------|-------------|
| MAC Address | Hardware identity | Randomized |
| IP Address | Network location | Renewed |

---
### Technical Flow
Detect network interface (eth0, wlan0)

Save original MAC address

Ask user for interval

Loop:
├── Generate random MAC address
├── Bring interface down
├── Apply new MAC address
├── Bring interface up
├── Release DHCP lease
├── Renew IP address
├── Display current MAC and IP
└── Wait for interval

Ctrl + C:
├── Stop execution
├── Restore original MAC
└── Exit safely
---

## 📋 Requirements

- Linux (Kali, Ubuntu, Debian, Arch, Fedora, Parrot)
- Root privileges (`sudo`)
- DHCP-enabled network

### Required Packages
- `iproute2` (for MAC manipulation)
- `isc-dhcp-client` (for IP renewal)

---

## 🚀 Installation
git clone https://github.com/Dhrub001/ip-mac-changer.git
cd ip-mac-changer
chmod +x ip-mac-pro
sudo ./ip-mac-pro

🎮 Usage


sudo ./ip-mac-pro

Interval Options
Choice	Interval	Mode
1	10 seconds	Movie Mode (Very Fast)
2	20 seconds	Turbo Mode
3	30 seconds	Normal Mode (Recommended)
4	60 seconds	Stealth Mode
5	Custom	Your own value
🎬 Example Output
text

╔═══════════════════════════════════════════════════════════╗
║        IP & MAC ADDRESS CHANGER v1.0                     ║
║         Author: Dhrub Raj Giri (DRG)                     ║
║              "HACK THE PLANET!"                          ║
╚═══════════════════════════════════════════════════════════╝

[i] Interface: eth0
[i] Original MAC: 00:0c:29:30:94:72

╔════════════════════════════════════════════════════════╗
║              SELECT CHANGE INTERVAL                    ║
╚════════════════════════════════════════════════════════╝

    1) 10 seconds  - Movie Mode (Very Fast)
    2) 20 seconds  - Turbo Mode
    3) 30 seconds  - Normal Mode (Recommended)
    4) 60 seconds  - Stealth Mode
    5) Custom      - Enter your own value

[?] Enter your choice [1-5]: 3

[✓] Interval: 30 seconds - Normal Mode

════════════════════════════════════════════
[🌀] CHANGE CYCLE #1
════════════════════════════════════════════
[→] Changing MAC address...
[✓] MAC changed: 02:ab:cd:ef:12:34
[→] Renewing IP address (DHCP)...
[✓] New IP: 192.168.1.105

📡 Current Status:
   MAC: 02:ab:cd:ef:12:34
   IP:  192.168.1.105

[⏰] Next change in 30 seconds...

🔍 Verification
Watch MAC Changes
bash

watch -n 1 'ip link show eth0 | grep ether'

Watch IP Changes
bash

watch -n 1 'ip -4 addr show eth0 | grep -oP "(?<=inet\s)\d+(\.\d+){3}"'

Verify MAC Restore on Exit
bash

# Check original MAC
ip link show eth0 | grep ether

# Run tool, then press Ctrl+C

# Check MAC again
ip link show eth0 | grep ether

🛠️ Troubleshooting
MAC Change Failed
bash

# Find your interface name
ip link show

# Try manual change
sudo ip link set dev eth0 down
sudo ip link set dev eth0 address 02:11:22:33:44:55
sudo ip link set dev eth0 up

DHCP Issues
bash

# Install DHCP client
sudo apt install isc-dhcp-client

# Manually renew IP
sudo dhclient -r eth0
sudo dhclient eth0

Permission Error
bash

# Always use sudo
sudo ./ip-mac-pro

📁 Project Structure
text

ip-mac-changer/
├── ip-mac-pro     # Main script
├── README.md      # Documentation
├── LICENSE        # MIT License
└── .gitignore     # Git exclusions

👤 Author

Dhrub Raj Giri (DRG)

    🔐 Cybersecurity Enthusiast

    💻 Network Engineer

    🎬 Inspired by hacker movies

https://img.shields.io/badge/GitHub-Dhrub001-181717?style=flat&logo=github
⭐ Support

If this tool made you feel like a movie hacker:

    ⭐ Star this repository

    🐛 Report issues

    🔄 Share with others

⚠️ Disclaimer

This tool is for educational and authorized testing only.

Do NOT use on:

    Public networks without permission

    Systems you do not own

The author is not responsible for misuse.
🙏 Acknowledgments

    Seniors & mentors for guidance

    Open-source community for tools

    Hacker movies for inspiration

📄 License

MIT License — see LICENSE file for details.

Made with ❤️ by Dhrub Raj Giri (DRG)
"HACK THE PLANET!" 🌍

⬆ Back to Top
text


---

## ✅ **What I Fixed**

| Issue | Fix |
|-------|-----|
| Missing badge links | Added proper GitHub links |
| Missing interval options table | Added clear table |
| Missing demo banner | Added complete ASCII output |
| Missing back to top link | Added at bottom |
| Code block formatting | Fixed all markdown |

---

## 🚀 **This README is 100% ready for GitHub!**

**Just copy and paste this entire code block into your `README.md` file.**

This response is AI-generated, for reference only.
