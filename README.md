# 🕵️ IP, MAC & Location Changer

[![Version](https://img.shields.io/badge/version-2.0-blue.svg)](https://github.com/Dhrub001/ip-mac-changer)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Linux-lightgrey.svg)](https://www.linux.org)
[![Shell](https://img.shields.io/badge/shell-bash-red.svg)](https://www.gnu.org/software/bash/)

> **"DISAPPEAR WITHOUT A TRACE!"** 🌍  
> Advanced IP, MAC & Location changer with Tor integration. Auto-rotate identity at custom intervals.

---

## 📖 The Story

Growing up watching hacker movies like *Mr. Robot*, *Whoami*, and *Sneakers*, I was fascinated by how attackers could instantly change their digital identity **AND location**.

That iconic line — **"I'm in."** — inspired me to explore networking and cybersecurity more deeply.

After weeks of hands-on practice, debugging, and learning from seniors (with some AI assistance), I built this tool to simulate "movie-style" identity switching in a real Linux environment.

⚠️ This is **not true anonymity** — it is a **learning and experimentation tool**.

---

## 🛠️ Tools Included in This Repository

| Script | What it does | Requires Tor |
|--------|-------------|--------------|
| **ip-mac-pro** | Main menu-driven tool with 5 modes | Optional |
| **anonymizer.sh** | Simple full anonymizer (MAC + IP + Location) | ✅ Yes |
| **stop.sh** | Stops all services, restores original MAC and network | - |
| **monitor.sh** | Live visual monitoring of MAC, IP, Tor location | - |
| **install.sh** | One-command installer for all dependencies | - |

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🖥️ **MAC Spoofing** | Change hardware address randomly |
| 🌐 **IP Renewal** | Get new DHCP lease |
| 📍 **Location Change** | Change Tor exit node (apparent location) |
| 🔄 **Auto-Rotate** | Continuous mode with custom intervals |
| ⚡ **One Shot** | Change once and exit |
| 🛑 **STOP Button** | Stop all services and restore network |
| 🎯 **Multiple Modes** | Full, IP/MAC only, or Location only |
| 📊 **Live Monitor** | Visual dashboard showing all changes |

---

## 🆕 What's New in v2.0

- ✅ **Location Changing** - Change your apparent geographic location via Tor
- ✅ **STOP Option** - Menu option to stop all services
- ✅ **Command Line Stop** - `--stop` flag to kill everything
- ✅ **Multiple Modes** - Choose what to change
- ✅ **Better Tor Integration** - Automatic setup and cleanup
- ✅ **Two Separate Scripts** - Use with or without Tor
- ✅ **Live Monitor Script** - Track all changes in real-time
- ✅ **One-Command Installer** - Automatic dependency setup

---

## 🎯 Purpose

| Purpose | Description |
|---------|-------------|
| 🎓 Learning | Understand MAC spoofing, DHCP & Tor |
| 🔬 Testing | Observe network behavior |
| 🎬 Simulation | Experience hacker-style operations |
| 🛡️ Practice | Basic privacy experimentation |

---

## ⚠️ Scope & Limitations

### ✔ What it DOES
- Changes MAC address (Layer 2 identity)
- Renews IP via DHCP
- Changes Tor exit node (apparent location)
- Automates repeated execution
- Restores original settings on stop

### ✖ What it DOES NOT DO
- Provide true anonymity
- Bypass ISP tracking completely
- Replace professional VPN/Tor setup
- Hide you from determined adversaries

---

## 📋 Prerequisites & Requirements

### System Requirements
- Linux (Kali, Ubuntu, Debian, Arch, Fedora, Parrot)
- Root privileges (`sudo`)
- DHCP-enabled network
- Internet connection (for Tor location changing)

### Required Packages (auto-installed by install.sh)

| Package | Purpose |
|---------|---------|
| `tor` | Anonymity network for location changing |
| `macchanger` | MAC address spoofing |
| `isc-dhcp-client` | DHCP IP renewal |
| `curl` | Public IP and location lookup |
| `netcat-openbsd` | Tor control port communication |

### Manual Dependency Installation

If you don't want to use the installer, run:

```bash
sudo apt update
sudo apt install tor macchanger isc-dhcp-client curl netcat-openbsd -y
