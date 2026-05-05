## You're absolutely right! My apologies for the confusion.

Let me give you the **COMPLETE README.md** as a **single code block** - ready to copy and paste directly into your `README.md` file.

No broken formatting, no missing parts. Just **copy this whole thing**:

---

```markdown
# 🕵️ IP & MAC Changer

[![Version](https://img.shields.io/badge/version-1.0-blue.svg)](https://github.com/Dhrub001/ip-mac-changer)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Bash](https://img.shields.io/badge/shell-bash-red.svg)](https://www.gnu.org/software/bash/)
[![Platform](https://img.shields.io/badge/platform-Linux-lightgrey.svg)]()

> **"HACK THE PLANET!"** - Change your MAC address and renew your IP automatically at custom intervals.

---

## 📖 The Story

Growing up watching hacker movies like *Mr. Robot*, *Whoami*, and *Sneakers*, I was always fascinated by how the protagonists would instantly change their digital identity and disappear without a trace. **"I'm in."** — that one line from every hacker movie inspired me to build this tool.

After weeks of research, countless cups of coffee ☕, and with guidance from my seniors and AI assistance, I finally created something that brings that movie magic to real life.

**What does it do?** It changes your MAC address and renews your IP address every few seconds - just like in the movies!

**Is it real anonymity?** No. This is for learning, experimenting, and having fun. True anonymity requires VPNs and Tor.

**Hope you like it!** 🚀

*— Dhrub Raj Giri (DRG)*

---

## 🎯 Purpose of This Tool

| Purpose | Description |
|---------|-------------|
| 🎓 **Learn Networking** | Understand how MAC addresses and DHCP work |
| 🎬 **Movie Feeling** | Experience what hackers see in movies |
| 🔬 **Testing** | Test how networks react to MAC changes |
| 🛡️ **Privacy Practice** | Learn basic privacy techniques |

**What it DOES change:**
- ✅ Your MAC address (local network ID)
- ✅ Your local IP (via DHCP renew)

**What it DOES NOT change:**
- ❌ Your public IP address (need VPN/Tor for that)
- ❌ Your physical location
- ❌ Your ISP tracking

---

## ⚙️ How It Works

### Simple Explanation:

| Identifier | What it is | What the tool does |
|------------|-----------|-------------------|
| **MAC Address** | A permanent hardware ID (like a fingerprint) | Changes it to a random fake ID |
| **IP Address** | Your current location on the network | Renews it to get a new number |

### Technical Flow:

```
1. Tool detects your network interface (eth0, wlan0, etc.)
                    ↓
2. Saves your original MAC address
                    ↓
3. Asks: "How often should I change? (10s, 20s, 30s, etc.)"
                    ↓
4. Starts the loop:
   ├── Generates random MAC address
   ├── Takes interface down
   ├── Changes MAC to random value
   ├── Brings interface up
   ├── Releases old IP (DHCP release)
   ├── Requests new IP (DHCP renew)
   ├── Shows new MAC and IP
   └── Waits X seconds, then repeats
                    ↓
5. When you press Ctrl+C:
   ├── Restores original MAC address
   └── Exits cleanly
```

---

## 🎬 Demo Output

```
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
[!] Press Ctrl+C to stop and restore original MAC

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
```

---

## 📋 Prerequisites

- **OS:** Linux (Kali, Ubuntu, Debian, Arch, Fedora, Parrot)
- **Access:** Sudo/root privileges
- **Network:** DHCP enabled (most home networks)
- **Space:** ~50KB

---

## 🚀 Installation

### Quick Install (One Line):

```bash
git clone https://github.com/Dhrub001/ip-mac-changer.git
cd ip-mac-changer
chmod +x ip-mac-pro
sudo ./ip-mac-pro
```

### Step-by-Step Install:

```bash
# 1. Clone the repository
git clone https://github.com/Dhrub001/ip-mac-changer.git

# 2. Go into the folder
cd ip-mac-changer

# 3. Make the script executable
chmod +x ip-mac-pro

# 4. Run it (must use sudo)
sudo ./ip-mac-pro
```

### System-Wide Install (Optional):

```bash
# Copy to system path
sudo cp ip-mac-pro /usr/local/bin/

# Now run from anywhere
sudo ip-mac-pro
```

---

## 🎮 How to Use

### Step 1: Run the tool
```bash
sudo ./ip-mac-pro
```

### Step 2: Choose your interval
```
Enter your choice [1-5]:
- Press 1 → 10 seconds (Movie Mode)
- Press 2 → 20 seconds (Turbo Mode)
- Press 3 → 30 seconds (Normal Mode)
- Press 4 → 60 seconds (Stealth Mode)
- Press 5 → Enter custom seconds
```

### Step 3: Watch it work
- MAC address changes every cycle
- IP address renews
- Status shows current MAC and IP

### Step 4: Stop the tool
Press `Ctrl+C` → Original MAC is restored automatically

---

## 🔍 How to Verify It's Working

### Test 1: Watch MAC Change (Open another terminal)

```bash
watch -n 1 'ip link show eth0 | grep ether'
```

**Expected:** The MAC address changes every cycle.

### Test 2: Watch IP Change

```bash
watch -n 1 'ip -4 addr show eth0 | grep -oP "(?<=inet\s)\d+(\.\d+){3}"'
```

### Test 3: Verify MAC Restore

```bash
# Step A: Check original MAC
ip link show eth0 | grep ether

# Step B: Run tool
sudo ./ip-mac-pro
# Press Ctrl+C after a few cycles

# Step C: Check MAC again
ip link show eth0 | grep ether
```

**Expected:** MAC is back to original value.

---

## 🛠️ Commands Reference

| Command | What it does |
|---------|-------------|
| `sudo ./ip-mac-pro` | Run the tool |
| `Ctrl+C` | Stop and restore original MAC |
| `watch -n 1 'ip link show eth0'` | Watch MAC changes live |
| `ip link show eth0 | grep ether` | Check current MAC |
| `sudo dhclient -r eth0 && sudo dhclient eth0` | Manually renew IP |

---

## 🔧 Troubleshooting

### Issue: "MAC change failed"

```bash
# Find your interface name
ip link show

# Try manual change
sudo ip link set dev eth0 down
sudo ip link set dev eth0 address 02:11:22:33:44:55
sudo ip link set dev eth0 up
```

### Issue: "No IP assigned"

```bash
# Check if DHCP client is running
ps aux | grep dhclient

# Install if missing
sudo apt install isc-dhcp-client
```

### Issue: "Permission denied"

```bash
# Always use sudo
sudo ./ip-mac-pro
```

---

## 📁 Project Structure

```
ip-mac-changer/
├── ip-mac-pro     # Main script (executable)
├── README.md      # Documentation
├── LICENSE        # MIT License
└── .gitignore     # Git exclusions
```

---

## 👤 Author

**Dhrub Raj Giri (DRG)**

[![GitHub](https://img.shields.io/badge/GitHub-Dhrub001-181717?style=flat&logo=github)](https://github.com/Dhrub001)
[![YouTube](https://img.shields.io/badge/YouTube-TechChip-FF0000?style=flat&logo=youtube)](https://youtube.com/@techchip)

- 🔐 Cybersecurity Enthusiast
- 🎬 Inspired by hacker movies
- 💻 First cybersecurity project

---

## 📄 License

MIT License - See [LICENSE](LICENSE) file for details.

---

## ⭐ Support

If this tool made you feel like a movie hacker:
- ⭐ **Star** this repository
- 🐛 **Report** issues
- 🔄 **Share** with friends

---

## ⚠️ Disclaimer

This tool is for **educational purposes only**. Use on your own network. The author assumes no liability for misuse.

---

## 🙏 Acknowledgments

- My seniors for guidance
- AI assistance for debugging
- Hacker movies for inspiration

---

**Made with ❤️ by Dhrub Raj Giri (DRG)**  
*"HACK THE PLANET!"* 🌍

---

[⬆ Back to Top](#-ip--mac-changer)
```

---

## ✅ That's it!

**Copy the entire code block above** and paste it directly into your `README.md` file.

This is a **complete, working README** with:
- Your story ✓
- Purpose ✓
- How it works ✓
- Installation ✓
- Verification ✓
- Professional formatting ✓

No missing parts, no broken formatting. Just copy and paste! 🚀# 🕵️ IP & MAC Changer

[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/Dhrub001/ip-mac-changer/releases)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Bash](https://img.shields.io/badge/shell-bash-4EAA25.svg)](https://www.gnu.org/software/bash/)
[![Tor](https://img.shields.io/badge/Tor-Integrated-7D4698.svg)](https://www.torproject.org/)
[![Linux](https://img.shields.io/badge/platform-Linux-FCC624.svg)](https://www.linux.org/)
[![Stars](https://img.shields.io/github/stars/Dhrub001/ip-mac-changer.svg)](https://github.com/Dhrub001/ip-mac-changer/stargazers)
[![Issues](https://img.shields.io/github/issues/Dhrub001/ip-mac-changer.svg)](https://github.com/Dhrub001/ip-mac-changer/issues)

> **Enterprise-grade IP rotation and MAC address spoofing automation for privacy research, penetration testing labs, and network security education.**

---

## 📖 The Story

Every hacker movie has *that scene* — the protagonist's location jumps from New York to Tokyo to Berlin in seconds, their digital footprint vanishing like smoke. **"I'm in."**

This tool is my attempt to bring that movie magic to real life. Built from weeks of research, late-night debugging sessions, and a genuine passion for network security, this project bridges the gap between Hollywood fantasy and practical cybersecurity.

**This isn't just a script. It's proof that curiosity + persistence = mastery.**

— *Dhrub Raj Giri (DRG)*

---

## 📌 Overview

`ip-mac-changer` automates two fundamental anonymity techniques used in professional cybersecurity:

| Technique | Implementation | Purpose |
|-----------|---------------|---------|
| **IP Rotation** | Tor `NEWNYM` signal via control port (9051) | Circuit-level anonymity |
| **MAC Spoofing** | `iproute2` randomization (locally administered addresses) | Layer 2 identity masking |

Built as a **production-ready systemd service** with configurable intervals, structured logging, and multi-distribution support.

### Primary Use Cases

- 🧪 **Penetration Testing Labs** - Realistic red team simulations
- 🔬 **Privacy Research** - Tor behavior analysis and testing
- 🎓 **Cybersecurity Education** - Hands-on Linux networking
- 🛡️ **Network Anomaly Detection** - Testing monitoring systems

---

## ✨ Key Features

| Category | Features |
|----------|----------|
| **IP Management** | 🔄 Automated Tor circuit renewal • 🌍 Geo-location tracking • 🛡️ SOCKS5 proxy routing |
| **MAC Management** | 🎭 Random locally administered addresses • 🔁 Optional auto-restore • 📡 Interface auto-detection |
| **Service Architecture** | 🖥️ systemd integration • 🔄 Auto-restart on failure • 📊 Persistent logging |
| **Configuration** | ⚙️ Interval: 10-300 seconds • 🎬 Preset modes • 💾 Hot-reloadable config |
| **Compatibility** | 🐧 8+ Linux distributions • 🔧 No external dependencies beyond Tor |

---

## 🧠 Technical Architecture

### System Flow Diagram
# 🕵️ IP & MAC Changer

[![Version](https://img.shields.io/badge/version-1.0-blue.svg)](https://github.com/Dhrub001/ip-mac-changer)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Bash](https://img.shields.io/badge/shell-bash-red.svg)](https://www.gnu.org/software/bash/)
[![Tor](https://img.shields.io/badge/Tor-Integrated-purple.svg)](https://www.torproject.org/)
[![Platform](https://img.shields.io/badge/platform-Linux-lightgrey.svg)]()

> **"HACK THE PLANET!"** - A professional-grade IP and MAC address changer inspired by hacker movies.

---

## 📖 The Story Behind This Tool

Growing up watching hacker movies like *Mr. Robot*, *Whoami*, and *Sneakers*, I was always fascinated by how the protagonists would instantly change their IP address, spoof their MAC, and disappear without a trace. The iconic scenes where the matrix-like code scrolls down the screen while their location jumps from country to country in seconds always gave me chills.

**"I'm in."** 

That one line from every hacker movie inspired me to build this tool. After weeks of research, countless cups of coffee ☕, and with some assistance and guidance, I finally created something that brings that movie magic to real life.

Now, with a single command, you can:
- 🌍 **Teleport** your IP across the globe via Tor network
- 🎭 **Spoof** your MAC address to a completely random identity
- ⚡ **Change** both at intervals as fast as 10 seconds (Movie Mode!)

This isn't just a tool - it's my tribute to every hacker movie that made us believe that with enough determination, anyone can master the digital realm.

**Hope you like it!** 🚀

*— Dhrub Raj Giri (DRG)*

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🔄 **Auto IP Rotation** | Change IP via Tor network at your specified interval |
| 🎭 **MAC Spoofing** | Generate completely random, locally administered MAC addresses |
| ⚡ **Movie Mode** | Change as fast as every 10 seconds |
| 🛡️ **Tor Integration** | Secure anonymous IP changes with automatic Tor control |
| 📍 **Location Tracking** | See your virtual location jump across countries |
| 🖥️ **Background Service** | Runs as systemd service, survives terminal closure |
| 📊 **Detailed Logging** | Every change logged for auditing |
| 🎨 **Movie-Style UI** | Cool hacker-themed ASCII banner & colored output |
| 💻 **Multi-Distro** | Kali, Ubuntu, Parrot, Arch, Fedora, OpenSUSE |
| 🔄 **Auto-Restore** | Original MAC restored on exit (optional) |

---

## 📋 Prerequisites

Before installing, ensure you have:

- **OS**: Linux-based (Kali, Ubuntu, Parrot, Arch, Fedora, OpenSUSE)
- **Privileges**: Sudo/root access
- **Internet**: Working connection
- **Storage**: ~50MB free space
- **Passion**: Love for hacker movies 🎬

---

## 🚀 Installation Guide

### Method 1: One-Line Installation (Recommended)

```bash
git clone https://github.com/Dhrub001/ip-mac-changer.git
cd ip-mac-changer
chmod +x setup.sh
./setup.sh# 🕵️ IP & MAC Changer

[![Version](https://img.shields.io/badge/version-1.0-blue.svg)](https://github.com/Dhrub001/ip-mac-changer)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Bash](https://img.shields.io/badge/shell-bash-red.svg)](https://www.gnu.org/software/bash/)
[![Tor](https://img.shields.io/badge/Tor-Integrated-purple.svg)](https://www.torproject.org/)
[![Platform](https://img.shields.io/badge/platform-Linux-lightgrey.svg)]()

> **"HACK THE PLANET!"** - A professional-grade IP and MAC address changer inspired by hacker movies. Automatically rotate your IP address through the Tor network and spoof your MAC address at custom intervals.

## ✨ Features

- 🔄 **Automatic IP Rotation** - Change IP via Tor network at your specified interval
- 🎭 **MAC Address Spoofing** - Generate completely random MAC addresses
- ⚡ **Real-time Changes** - As fast as every 10 seconds (movie mode!)
- 🛡️ **Tor Integration** - Secure anonymous IP changes
- 📍 **Location Tracking** - See where your new IP is geolocated
- 🖥️ **Background Service** - Runs as systemd service
- 📊 **Detailed Logging** - All activities logged for auditing
- 🎨 **Movie-style UI** - Cool hacker-themed terminal output
- 💻 **Multi-distro Support** - Kali, Ubuntu, Parrot, Arch, Fedora, OpenSUSE

## 📋 Prerequisites

- Linux-based OS (Kali, Ubuntu, Parrot, Arch, Fedora, OpenSUSE)
- Sudo privileges
- Internet connection
- ~50MB free disk space

## 🚀 Quick Installation

### One-line Installation (Recommended)

```bash
git clone https://github.com/Dhrub001/ip-mac-changer.git
cd ip-mac-changer
chmod +x setup.sh
./setup.sh# 🕵️ IP & MAC Changer

[![Version](https://img.shields.io/badge/version-1.0-blue.svg)](https://github.com/Dhrub001/ip-mac-changer)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Bash](https://img.shields.io/badge/shell-bash-red.svg)](https://www.gnu.org/software/bash/)
[![Tor](https://img.shields.io/badge/Tor-Integrated-purple.svg)](https://www.torproject.org/)
[![Platform](https://img.shields.io/badge/platform-Linux-lightgrey.svg)]()

> **"HACK THE PLANET!"** - A professional-grade IP and MAC address changer inspired by hacker movies. Automatically rotate your IP address through the Tor network and spoof your MAC address at custom intervals.

## ✨ Features

- 🔄 **Automatic IP Rotation** - Change IP via Tor network at your specified interval
- 🎭 **MAC Address Spoofing** - Generate completely random MAC addresses
- ⚡ **Real-time Changes** - As fast as every 10 seconds (movie mode!)
- 🛡️ **Tor Integration** - Secure anonymous IP changes
- 📍 **Location Tracking** - See where your new IP is geolocated
- 🖥️ **Background Service** - Runs as systemd service
- 📊 **Detailed Logging** - All activities logged for auditing
- 🎨 **Movie-style UI** - Cool hacker-themed terminal output
- 💻 **Multi-distro Support** - Kali, Ubuntu, Parrot, Arch, Fedora, OpenSUSE

## 🎬 Demo
╔═══════════════════════════════════════════════════════════╗
║ ║
║ ██▓ ██▓███ ▄▄▄ ▄▄▄█████▓ ▄████▄ ██░ ██ ▄▄▄ ║
║ ▓██▒▓██░ ██▒▒████▄ ▓ ██▒ ▓▒▒██▀ ▀█ ▓██░ ██▒████▄ ║
║ ▒██▒▓██░ ██▓▒▒██ ▀█▄ ▒ ▓██░ ▒░▒▓█ ▄ ▒██▀▀██░▒██ ▀█▄ ║
║ ░██░▒██▄█▓▒ ▒░██▄▄▄▄██ ░ ▓██▓ ░ ▒▓▓▄ ▄██▒░▓█ ░██ ░██▄▄▄▄██║
║ ░██░▒██▒ ░ ░ ▓█ ▓██▒ ▒██▒ ░ ▒ ▓███▀ ░░▓█▒░██▓ ▓█ ▓██║
║ ░▓ ▒▓▒░ ░ ░ ▒▒ ▓▒█░ ▒ ░░ ░ ░▒ ▒ ░ ▒ ░░▒░▒ ▒▒ ▓▒█║
║ ▒ ░░▒ ░ ▒ ▒▒ ░ ░ ░ ▒ ▒ ░▒░ ░ ▒ ▒▒ ░║
║ ▒ ░░░ ░ ▒ ░ ░ ░ ░░ ░ ░ ▒ ║
║ ░ ░ ░ ░ ░ ░ ░ ░ 3║
║ ║
║ IP & MAC ADDRESS CHANGER v1.0 ║
║ Author: Dhrub Raj Giri ║
║ "HACK THE PLANET!" ║
╚═══════════════════════════════════════════════════════════╝

## 📋 Prerequisites

- Linux-based OS (Kali, Ubuntu, Parrot, Arch, Fedora, OpenSUSE)
- Sudo privileges
- Internet connection
- ~50MB free disk space

## 🚀 Quick Installation

### One-line Installation (Recommended)

```bash
git clone https://github.com/Dhrub001/ip-mac-changer.git
cd ip-mac-changer
chmod +x setup.sh
./setup.sh
