Understood — you want a **single clean README.md with no explanations, no extras, no commentary, just copy-paste ready**.

Here is your **FINAL READY-TO-USE README** 👇

```markdown
# 🕵️ IP & MAC Changer

[![Version](https://img.shields.io/badge/version-1.0-blue.svg)](https://github.com/Dhrub001/ip-mac-changer)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Linux-lightgrey.svg)]()
[![Shell](https://img.shields.io/badge/shell-bash-red.svg)]()

> **"HACK THE PLANET!"** 🌍  
> Automate MAC address spoofing and DHCP IP renewal at custom intervals.

---

## 📖 The Story

Growing up watching hacker movies like *Mr. Robot*, *Whoami*, and *Sneakers*, I was fascinated by how attackers could instantly change their digital identity and disappear.

That iconic line — **"I'm in."** — inspired me to explore networking and cybersecurity more deeply.

After weeks of hands-on practice, debugging, and learning from seniors (with some AI assistance), I built this tool to simulate “movie-style” identity switching in a real Linux environment.

⚠️ This is **not true anonymity** — it is a **learning and experimentation tool**.

---

## 🎯 Purpose

| Purpose       | Description                        |
|--------------|------------------------------------|
| 🎓 Learning   | Understand MAC spoofing & DHCP     |
| 🔬 Testing    | Observe network behavior           |
| 🎬 Simulation | Experience hacker-style operations |
| 🛡️ Practice  | Basic privacy experimentation      |

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

| Identifier   | Meaning           | Tool Action |
|--------------|------------------|-------------|
| MAC Address  | Hardware identity | Randomized  |
| IP Address   | Network location  | Renewed     |

---

### Technical Flow

```

1. Detect network interface (eth0, wlan0)
2. Save original MAC address
3. Ask user for interval
4. Loop:
   ├── Generate random MAC address
   ├── Bring interface down
   ├── Apply new MAC address
   ├── Bring interface up
   ├── Release DHCP lease
   ├── Renew IP address
   ├── Display current MAC and IP
   └── Wait for interval
5. Ctrl + C:
   ├── Stop execution
   ├── Restore original MAC
   └── Exit safely

````

---

## 📋 Requirements

- Linux (Kali, Ubuntu, Debian, Arch, Fedora, Parrot)
- Root privileges (`sudo`)
- DHCP-enabled network

### Required Packages
- iproute2
- isc-dhcp-client

---

## 🚀 Installation

```bash
git clone https://github.com/Dhrub001/ip-mac-changer.git
cd ip-mac-changer
chmod +x ip-mac-pro
sudo ./ip-mac-pro
````

---

## 🎮 Usage

```bash
sudo ./ip-mac-pro
```

---

## 🎬 Example Output

```
[+] Interface: eth0
[+] Original MAC: 00:0c:29:30:94:72

[✓] Interval: 30 seconds

[CHANGE #1]
→ Changing MAC...
✓ MAC: 02:ab:cd:ef:12:34

→ Renewing IP...
✓ IP: 192.168.1.105
```

---

## 🔍 Verification

### Watch MAC Changes

```bash
watch -n 1 'ip link show eth0 | grep ether'
```

### Watch IP Changes

```bash
watch -n 1 'ip -4 addr show eth0'
```

### Verify Restore

```bash
ip link show eth0 | grep ether
```

---

## 🛠️ Troubleshooting

### MAC Change Failed

```bash
ip link show
sudo ip link set dev eth0 down
sudo ip link set dev eth0 address 02:11:22:33:44:55
sudo ip link set dev eth0 up
```

### DHCP Issues

```bash
sudo apt install isc-dhcp-client
sudo dhclient -r eth0
sudo dhclient eth0
```

### Permission Error

```bash
sudo ./ip-mac-pro
```

---

## 📁 Project Structure

```
ip-mac-changer/
├── ip-mac-pro
├── README.md
├── LICENSE
└── .gitignore
```

---

## 👤 Author

**Dhrub Raj Giri (DRG)**
Cybersecurity Enthusiast
Network Engineer

GitHub: [https://github.com/Dhrub001](https://github.com/Dhrub001)

---

## ⚠️ Disclaimer

This tool is for **educational and authorized testing only**.

Do not use on networks you do not own or have permission to test.

---

## 📄 License

MIT License

```

---

If you want next step, I can help you make this:
🔥 look like a **top cybersecurity GitHub project (portfolio level)** with diagram + badge + banner.
```
