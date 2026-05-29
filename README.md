# 🕵️ IP, MAC & Location Changer

[![Version](https://img.shields.io/badge/version-2.0-blue.svg)](https://github.com/Dhrub001/ip-mac-changer)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Linux-lightgrey.svg)](https://www.linux.org)
[![Shell](https://img.shields.io/badge/shell-bash-red.svg)](https://www.gnu.org/software/bash/)

> **"DISAPPEAR WITHOUT A TRACE!"** 🌍
> Advanced IP, MAC & Location changer with Tor integration and automated identity rotation.

---

# 📖 The Story

Growing up watching hacker movies like *Mr. Robot*, *Whoami*, and *Sneakers*, I became fascinated by how attackers could instantly change their digital identity and apparent location.

That iconic phrase — **"I'm in."** — inspired me to dive deeper into networking and cybersecurity.

After weeks of testing, debugging, experimenting, and learning from mentors (plus some AI assistance), I created this project to simulate “movie-style” identity switching in a real Linux environment.

⚠️ This project is a **learning and experimentation tool** — not a true anonymity solution.

---

# 🛠️ Included Tools

| Script          | Description                         | Requires Tor |
| --------------- | ----------------------------------- | ------------ |
| `ip-mac-pro`    | Main menu-driven anonymizer tool    | Optional     |
| `anonymizer.sh` | Simple MAC + IP + Location changer  | ✅ Yes        |
| `stop.sh`       | Stops services and restores network | ❌ No         |
| `monitor.sh`    | Live monitoring dashboard           | ❌ No         |
| `install.sh`    | One-command dependency installer    | ❌ No         |

---

# ✨ Features

| Feature               | Description                         |
| --------------------- | ----------------------------------- |
| 🖥️ MAC Spoofing      | Randomize hardware MAC address      |
| 🌐 IP Renewal         | Renew DHCP lease automatically      |
| 📍 Location Switching | Rotate Tor exit node locations      |
| 🔄 Auto Rotation      | Repeat changes at custom intervals  |
| ⚡ One-Shot Mode       | Change identity once and exit       |
| 🛑 Emergency Stop     | Restore original network settings   |
| 📊 Live Monitor       | View real-time identity changes     |
| 🎯 Multiple Modes     | Choose specific anonymization types |

---

# 🆕 What's New in v2.0

* ✅ Tor-based location changing
* ✅ STOP option for restoring network
* ✅ `--stop` command-line support
* ✅ Multiple anonymization modes
* ✅ Improved Tor integration
* ✅ Separate lightweight scripts
* ✅ Real-time monitor dashboard
* ✅ Automated dependency installer

---

# 🎯 Purpose

| Use Case             | Description                     |
| -------------------- | ------------------------------- |
| 🎓 Learning          | Learn MAC spoofing, DHCP & Tor  |
| 🔬 Testing           | Observe network behavior        |
| 🎬 Simulation        | Practice hacker-style workflows |
| 🛡️ Privacy Practice | Basic anonymity experimentation |

---

# ⚠️ Scope & Limitations

## ✔ What It DOES

* Changes MAC address
* Renews local IP address
* Changes Tor exit location
* Automates repeated identity rotation
* Restores original settings safely

## ✖ What It DOES NOT DO

* Provide true anonymity
* Fully hide ISP activity
* Replace professional VPN/Tor configurations
* Defeat advanced tracking systems

---

# 📋 Requirements

## Supported Systems

* Kali Linux
* Ubuntu
* Debian
* Arch Linux
* Fedora
* Parrot OS

## Required Packages

| Package           | Purpose                   |
| ----------------- | ------------------------- |
| `tor`             | Tor network               |
| `macchanger`      | MAC spoofing              |
| `isc-dhcp-client` | DHCP renewal              |
| `curl`            | IP/location checks        |
| `netcat-openbsd`  | Tor control communication |

---

# 🚀 Installation

## Method 1 — Recommended

```bash
git clone https://github.com/Dhrub001/ip-mac-changer.git
cd ip-mac-changer
sudo ./install.sh
```

---

## Method 2 — Manual Setup

```bash
git clone https://github.com/Dhrub001/ip-mac-changer.git
cd ip-mac-changer

chmod +x ip-mac-pro
chmod +x anonymizer.sh
chmod +x stop.sh
chmod +x monitor.sh
chmod +x install.sh
```

Install dependencies manually:

```bash
sudo apt update
sudo apt install tor macchanger isc-dhcp-client curl netcat-openbsd -y
```

---

# 🎮 Usage

# Main Tool

```bash
sudo ./ip-mac-pro
```

## Available Modes

| Option | Mode            |
| ------ | --------------- |
| 1      | Full Anonymizer |
| 2      | IP & MAC Only   |
| 3      | Location Only   |
| 4      | One Shot        |
| 5      | STOP ALL        |

---

# Simple Anonymizer

```bash
sudo ./anonymizer.sh
```

Changes MAC, IP, and Tor location repeatedly.

---

# Stop Everything

```bash
sudo ./stop.sh
```

Restores:

* Original MAC
* DHCP lease
* Tor configuration
* Network settings

---

# Live Monitor

```bash
./monitor.sh
```

Displays:

* MAC Address
* Local IP
* Public IP
* Tor IP
* Tor Location
* Tor Status

---

# 🛑 Stopping the Tool

| Method      | Command                    |
| ----------- | -------------------------- |
| Menu Option | Choose option 5            |
| Script      | `sudo ./stop.sh`           |
| Keyboard    | `Ctrl+C`                   |
| CLI Flag    | `sudo ./ip-mac-pro --stop` |

---

# 🔍 Verification Commands

## Check Current MAC

```bash
ip link show eth0 | grep ether
```

## Check Local IP

```bash
ip -4 addr show eth0
```

## Check Public IP

```bash
curl -s ifconfig.me
```

## Check Tor IP

```bash
curl --socks5-hostname localhost:9050 -s ifconfig.me
```

## Check Tor Status

```bash
systemctl status tor
```

---

# 🛠️ Troubleshooting

# MAC Not Changing

```bash
ip link show
```

Find the correct interface name first.

---

# DHCP Problems

```bash
sudo dhclient -r eth0
sudo dhclient eth0
```

---

# Tor Problems

```bash
sudo systemctl start tor
systemctl status tor
```

---

# Permission Denied

Always run with:

```bash
sudo
```

---

# 📁 Repository Structure

```text
ip-mac-changer/
├── ip-mac-pro
├── anonymizer.sh
├── stop.sh
├── monitor.sh
├── install.sh
├── README.md
├── LICENSE
└── .gitignore
```

---

# 👤 Author

## Dhrub Raj Giri (DRG)

* 🔐 Cybersecurity Enthusiast
* 🌐 Network Engineer
* 🎬 Inspired by hacker movies

### GitHub

https://github.com/Dhrub001

### LinkedIn

https://www.linkedin.com/in/dhrub-raj-giri-5633a714b/

---

# ⭐ Support

If you found this project useful:

* ⭐ Star the repository
* 🐛 Report bugs
* 💡 Suggest improvements
* 🔄 Share with others

---

# ⚠️ Disclaimer

This project is strictly for:

* Educational purposes
* Authorized testing
* Personal experimentation

Do NOT use this project for:

* Illegal activities
* Unauthorized access
* Public network abuse

The author is not responsible for misuse.

---

# 🙏 Acknowledgments

* Open-source community
* Mentors & seniors
* Tor Project
* Hacker movie inspiration

---

# 📄 License

MIT License — see the `LICENSE` file for details.

---

# ❤️ Final Note

**Made with passion by Dhrub Raj Giri (DRG)**

> *"HACK THE PLANET!"* 🌍
