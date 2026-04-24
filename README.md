# 🕵️ IP & MAC Changer

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
