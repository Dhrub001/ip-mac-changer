Your README is already **very strong**. I’ve only done **clean professional polishing**, fixed consistency, improved readability, and removed redundancy—without changing your meaning.

Here is your **FINAL COPY-PASTE READY README.md** 👇

---

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
   ├── Generate random MAC
   ├── Disable interface
   ├── Apply new MAC
   ├── Enable interface
   ├── DHCP release
   ├── DHCP renew
   ├── Display updated values
   └── Wait interval
5. Ctrl + C → Restore original MAC

````

---

## 🧠 Technical Breakdown

### 1. Interface Detection
```bash
ip link show
````

---

### 2. Backup Original MAC

```bash
ip link show eth0 | grep ether
```

---

### 3. Generate Random MAC

Example:

```
02:ab:cd:ef:12:34
```

* `02` → Locally administered address
* Remaining bytes → Randomized

---

### 4. Apply MAC Change

```bash
ip link set dev eth0 down
ip link set dev eth0 address <new-mac>
ip link set dev eth0 up
```

---

### 5. Renew IP Address

```bash
dhclient -r eth0
dhclient eth0
```

---

### 6. Continuous Loop

```bash
while true; do
   # change MAC
   # renew IP
   sleep <interval>
done
```

---

### 7. Safe Exit (Ctrl + C)

* Restores original MAC address
* Exits cleanly without network damage

---

## 🔄 Execution Pipeline

```
[Detect Interface]
        ↓
[Backup MAC]
        ↓
[Generate Random MAC]
        ↓
[Interface Down]
        ↓
[Apply MAC]
        ↓
[Interface Up]
        ↓
[DHCP Release → Renew]
        ↓
[Wait Interval]
        ↓
[Repeat]
```

---

## 📋 Requirements

* Linux (Kali, Ubuntu, Debian, Arch, Fedora, Parrot)
* Root privileges (`sudo`)
* DHCP-enabled network

### Required Packages

| Package           | Purpose                   |
| ----------------- | ------------------------- |
| `iproute2`        | Network interface control |
| `isc-dhcp-client` | DHCP IP renewal           |

---

## 🚀 Installation

### Quick Install

```bash
git clone https://github.com/Dhrub001/ip-mac-changer.git
cd ip-mac-changer
chmod +x ip-mac-pro
sudo ./ip-mac-pro
```

---

### System-wide Install (Optional)

```bash
sudo cp ip-mac-pro /usr/local/bin/ip-mac-pro
sudo ip-mac-pro
```

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

---

### Watch IP Changes

```bash
watch -n 1 'ip -4 addr show eth0'
```

---

### Verify Restore

```bash
ip link show eth0 | grep ether
```

✔ Run tool → Stop (Ctrl + C) → Check again
✔ Expected: Original MAC restored

---

## 🛠️ Troubleshooting

### MAC Change Failed

```bash
ip link show
sudo ip link set dev eth0 down
sudo ip link set dev eth0 address 02:11:22:33:44:55
sudo ip link set dev eth0 up
```

---

### DHCP Issues

```bash
sudo apt install isc-dhcp-client
sudo dhclient -r eth0
sudo dhclient eth0
```

---

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
🔐 Cybersecurity Enthusiast
💻 Network Engineer

GitHub: [https://github.com/Dhrub001](https://github.com/Dhrub001)

---

## ⚠️ Disclaimer

This tool is intended for **educational and authorized testing only**.

Do NOT use on:

* Public networks without permission
* Systems you do not own or control

The author is not responsible for misuse.

---

## ⭐ Support

If you like this project:

* ⭐ Star the repository
* 🐛 Report issues
* 🔄 Share with others

---

## 🙏 Acknowledgments

* Seniors & mentors
* Open-source community
* Cybersecurity learning resources

---

## 📄 License

This project is licensed under the MIT License.

---

**Made with ❤️ by Dhrub Raj Giri**
**"HACK THE PLANET!"** 🌍

```

---

## ✅ What I improved (important)
- Fixed formatting consistency
- Removed repetition
- Improved technical clarity
- Cleaned language for professionalism
- Made it recruiter-ready (important for GitHub visibility)

---

## 🚀 You are now ready

This README is:
- ✔ Professional
- ✔ Clean
- ✔ Portfolio-ready
- ✔ GitHub upload safe

---

If you want next upgrade, I can help you make this **TOP 1% GitHub project** with:
- 🔥 Architecture diagram (network flow image)
- 🎥 GIF demo (very high impact)
- 🧠 interview explanation script
- ⭐ GitHub SEO optimization (for recruiters)

Just tell me 👍
```
