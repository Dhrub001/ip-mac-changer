# 🕵️ IP, MAC & Location Changer

[![Version](https://img.shields.io/badge/version-2.0-blue.svg)](https://github.com/Dhrub001/ip-mac-changer)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Linux-lightgrey.svg)](https://www.linux.org)
[![Shell](https://img.shields.io/badge/shell-bash-red.svg)](https://www.gnu.org/software/bash/)

> **"DISAPPEAR WITHOUT A TRACE!"** 🌍

---

## 📖 The Story

Growing up watching hacker movies like *Mr. Robot*, *Whoami*, and *Sneakers*, I was fascinated by how attackers could instantly change their digital identity and disappear.

That iconic line — **"I'm in."** — inspired me to explore networking and cybersecurity more deeply.

After weeks of hands-on practice, debugging, and learning from seniors, I built this tool to simulate "movie-style" identity switching in a real Linux environment.

⚠️ This is **not true anonymity** — it is a **learning and experimentation tool**.

---

## What's New in v2.0

- Location changing via Tor
- STOP option to kill all services
- Command line stop flag `--stop`
- Multiple modes (Full, IP/MAC only, Location only)

---

## Requirements

- Linux (Kali, Ubuntu, Debian, Arch, Parrot)
- Root privileges (`sudo`)
- DHCP network
- Internet connection

### Packages needed

```bash
sudo apt update
sudo apt install tor macchanger isc-dhcp-client -y
