# 🕵️ IP, MAC & Location Changer

[![Version](https://img.shields.io/badge/version-2.0-blue.svg)](https://github.com/Dhrub001/ip-mac-changer)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Linux-lightgrey.svg)](https://www.linux.org)

> **"DISAPPEAR WITHOUT A TRACE!"** 🌍

---

## 📖 The Story

Growing up watching hacker movies like *Mr. Robot*, *Whoami*, and *Sneakers*, I was fascinated by how attackers could instantly change their digital identity and disappear.

After weeks of hands-on practice, debugging, and learning from seniors, I built this tool to simulate "movie-style" identity switching in a real Linux environment.

⚠️ **Educational tool only** - Not true anonymity

---

## 🛠️ Tools Included

| Script | What it does | Requires Tor |
|--------|-------------|--------------|
| `ip-mac-pro` | Changes MAC + IP (menu driven) | ❌ No |
| `anonymizer.sh` | Changes MAC + IP + Location | ✅ Yes |
| `stop.sh` | Stops all services, restores network | - |
| `monitor.sh` | Live view of MAC, IP, location | - |
| `install.sh` | One-command setup | - |

---

## 📋 Requirements

- Linux (Kali, Ubuntu, Debian, Parrot)
- Root privileges (`sudo`)
- DHCP network
- Internet connection (for Tor)

---

## 🚀 Quick Installation (One Command)

```bash
git clone https://github.com/Dhrub001/ip-mac-changer.git
cd ip-mac-changer
chmod +x install.sh
sudo ./install.sh
