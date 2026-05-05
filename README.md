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

---
🎮 Usage

sudo ./ip-mac-pro

---
