# IP, MAC & Tor Identity Changer

[![Version](https://img.shields.io/badge/version-2.1-blue.svg)](https://github.com/Dhrub001/ip-mac-changer)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Linux-lightgrey.svg)](https://www.linux.org)
[![Shell](https://img.shields.io/badge/shell-bash-red.svg)](https://www.gnu.org/software/bash/)

A small Linux toolkit that rotates three things on a timer, or once on demand:

- your network card's **MAC address**
- your **DHCP lease** (the local IP address your router hands you)
- your **Tor identity** (a new exit relay for traffic sent through Tor)

It is meant for learning and for testing in labs you own or are authorized to test. It is **not** a one-click way to become anonymous. Read [What it does and does not do](#what-it-does-and-does-not-do) before you rely on it.

## The story

Growing up watching *Mr. Robot*, *Whoami* and *Sneakers*, I was fascinated by how quickly a character could switch identity. That pushed me into networking and security. This project is my attempt to recreate that idea on a real Linux machine, and to learn how MAC spoofing, DHCP and Tor actually behave along the way.

## What it does and does not do

| It does | It does not |
|---------|-------------|
| Set a random MAC address on your interface, check that it took, and remember the **real** one | Change your **public IP address**. Your ISP or router decides that. |
| Ask for a fresh DHCP lease (you may get the same address back, which is normal) | Change the **location** websites see when you browse normally |
| Ask Tor for new circuits and show the new exit IP, country and city | Send your normal traffic through Tor. Only apps that use Tor's proxy do. |
| Restore the original MAC and stop Tor when you press Ctrl+C or run `stop.sh` | Hide you from your ISP, your router, or anyone who can see your local network |

The Tor exit shown by the tool applies to traffic sent to Tor's proxy at `127.0.0.1:9050`. See [Browsing through Tor](#browsing-through-tor) for how to use it.

## Quick start

```bash
git clone https://github.com/Dhrub001/ip-mac-changer.git
cd ip-mac-changer
sudo bash install.sh        # installs packages and makes the scripts executable
sudo ./ip-mac-pro           # opens the menu
```

`install.sh` supports apt-based systems: Kali, Parrot, Debian and Ubuntu. On other distributions, install `tor`, `curl`, the OpenBSD `netcat`, `iproute2`, `ethtool`, `procps`, `util-linux`, and either `dhclient` or NetworkManager, then run `chmod +x ip-mac-pro anonymizer.sh stop.sh monitor.sh`.

## Usage

### Menu

```bash
sudo ./ip-mac-pro
```

| Choice | Mode | What it does |
|--------|------|--------------|
| 1 | Full | MAC + IP + Tor identity, repeated |
| 2 | IP & MAC | MAC + IP only, repeated |
| 3 | Tor only | Tor identity only, repeated |
| 4 | One shot | Change once and exit |
| 5 | Stop | Restore the original settings |

### Command line

```bash
sudo ./ip-mac-pro --mode full --interval 60     # everything, every 60 seconds
sudo ./ip-mac-pro --mode netid -i wlan0         # MAC + IP only, on wlan0
sudo ./ip-mac-pro --mode once                   # change once, then exit
sudo ./ip-mac-pro --status                      # show current state (no changes)
sudo ./anonymizer.sh 120                        # shortcut for --mode full, every 120 s
```

| Option | Meaning |
|--------|---------|
| `-m, --mode` | `full`, `netid`, `tor` or `once` |
| `-t, --interval` | Seconds between changes. Minimum 10, default 60. |
| `-i, --iface` | Interface to use. Default: the one with the default route. |
| `-s, --stop` | Restore everything and stop Tor |
| `--status` | Show MAC, IP and Tor state |

Press **Ctrl+C** to stop a running loop. It puts your original MAC back, and stops Tor if the tool started it.

### Stop and restore

```bash
sudo ./stop.sh                 # restore the saved MAC, stop Tor
sudo ./stop.sh --keep-tor      # restore the MAC, leave Tor running
sudo ./stop.sh -i wlan0        # also force wlan0 back to its hardware MAC
```

The first time it changes a MAC, the tool saves the real (hardware) one in `/var/lib/ip-mac-changer/`. `stop.sh` restores from that copy, so it still works after a crash. If a spoofed MAC is stuck and no copy exists, use `--iface`.

### Live monitor

```bash
./monitor.sh                   # no root needed
./monitor.sh --once            # one snapshot, handy in scripts
```

It shows your MAC, local IP, public IP and Tor exit, and marks anything that changed. Public IP and Tor are checked every 30 seconds so the lookup sites are not overloaded.

## Browsing through Tor

Changing the Tor identity only matters for traffic that goes through Tor. Pick one:

| Method | How |
|--------|-----|
| Tor Browser | Use it as normal. It has its own Tor and is the safest choice for browsing. |
| `torsocks` | `torsocks curl https://check.torproject.org/api/ip` |
| `proxychains` | Set `socks5 127.0.0.1 9050` in its config, then `proxychains4 firefox` |
| Firefox | Settings, Network Settings, manual proxy: SOCKS5 `127.0.0.1` port `9050`, and tick *Proxy DNS when using SOCKS v5* |

Check that it works: the exit IP the tool prints should match what `torsocks curl https://check.torproject.org/api/ip` reports.

## Using it in a lab

- Rotating MAC and DHCP is useful for testing port security, DHCP behavior, NAC and logging on a network you own.
- Only do this on networks and systems you are authorized to test. Changing identifiers on someone else's network can break their rules or the law.
- Many Wi-Fi cards will not change MAC while connected. Disconnect first, or use `--mode tor`.
- On a laptop, NetworkManager may reconnect when the MAC changes. The tool handles this by asking NetworkManager to reconnect instead of running `dhclient` itself.
- On a virtual machine, the host or hypervisor still sees the virtual network card it assigned.

## How it works

| File | Purpose |
|------|---------|
| `ip-mac-pro` | Main tool: menu, modes, interval loop, Ctrl+C handling |
| `anonymizer.sh` | Shortcut for `ip-mac-pro --mode full` |
| `stop.sh` | Stops a running copy, restores the MAC, stops Tor |
| `monitor.sh` | Live view of MAC, IP and Tor |
| `install.sh` | Installs packages and enables Tor's local control port |
| `lib.sh` | Shared functions used by all of the above |
| `tests/run-tests.sh` | Offline tests that use fake network commands |

`install.sh` adds a short block between `# >>> ip-mac-changer >>>` and `# <<< ip-mac-changer <<<` to `/etc/tor/torrc`. It turns on a control port on `127.0.0.1:9051` with cookie authentication, which is how a new Tor identity is requested without restarting Tor. Your original file is saved as `/etc/tor/torrc.imc-backup`. If Tor does not accept the change, the installer puts your file back.

Installing Tor also starts it at boot. To stop that: `sudo systemctl disable tor`.

## Troubleshooting

| Problem | Fix |
|---------|-----|
| `Permission denied` when running a script | `chmod +x ip-mac-pro anonymizer.sh stop.sh monitor.sh install.sh`, or run it with `bash`, for example `sudo bash install.sh` |
| `This needs root` | Put `sudo` in front |
| `The driver refused the new MAC` | The card does not allow it while connected. Disconnect from Wi-Fi first. |
| `No DHCP answer` | Check the cable or Wi-Fi, then try `sudo ./stop.sh -i <iface>` |
| `Could not use Tor's control port` | Run `sudo ./install.sh` once. The tool restarts Tor as a fallback. |
| Tor will not connect | `systemctl status tor`. Some networks block Tor. |
| Wrong interface picked | Use `-i`, and list names with `ip link` |
| MAC stuck after a crash | `sudo ./stop.sh --iface <name>` |

## Tests

```bash
bash tests/run-tests.sh
```

The tests put fake `ip`, `dhclient`, `tor`, `nc`, `curl` and `systemctl` commands first on `PATH`, so they never touch your real network. They cover interface detection, MAC generation, saving and restoring the original MAC, the Tor control-port checks, the Ctrl+C restore, and the repository itself. `shellcheck` is run too if it is installed. The scripts have not been exercised against every real network card and network manager, so try a first run on a machine where a brief network drop is fine.

## What changed in 2.1

- **Restore now works.** The original MAC is read from the hardware and saved before the first change. Before, `stop.sh` treated the *current* (already spoofed) MAC as the original.
- **Honest output.** Every step is checked, and a failure is reported instead of printing a success message. Without root, the old scripts claimed to work and changed nothing.
- **Tor identity is verified.** The tool reads Tor's reply and shows the old and new exit IP. Before, it printed "Location changed" even when Tor's control port was off, which is the default.
- **Safe process handling.** `pkill -f tor`, which matches any process with "tor" in its command line, is gone. `stop.sh` no longer masks the Tor service.
- **Ctrl+C works in every mode**, immediately, and restores your settings. The main tool had no handler before.
- **Interface detection** handles VPN and Wi-Fi names. `monitor.sh` no longer assumes `eth0`.
- **Monitor** checks public IP and Tor every 30 seconds instead of every 2, because `ifconfig.me` rate-limits to about one request a minute.
- **One Shot** now rotates Tor too. Before, that code could never run.
- **Repository fixes:** the scripts are executable, line endings are LF, and `LICENSE` no longer starts with a pasted `cat > LICENSE << 'EOF'` line.
- **Shared code** moved into `lib.sh` instead of being copied across scripts. `macchanger` is no longer installed because it was never used.
- **NetworkManager** is used for the IP renewal when it manages the interface.
- **Offline tests** added.

## Disclaimer

This project is for education, authorized testing and personal experimentation.

Do not use it for illegal activity, unauthorized access or abuse of public networks. The author is not responsible for misuse.

## Author

**Dhrub Raj Giri (DRG)**, cybersecurity enthusiast and network engineer.

- GitHub: https://github.com/Dhrub001
- LinkedIn: https://www.linkedin.com/in/dhrub-raj-giri-5633a714b/

## License

MIT. See [LICENSE](LICENSE).
