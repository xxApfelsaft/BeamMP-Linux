# BeamMP-Linux

**Pre-compiled BeamMP Launcher binaries & automated build scripts for the native BeamNG.drive Linux client.**

[![Automated Release Build](https://github.com/xxApfelsaft/BeamMP-Linux/actions/workflows/release.yml/badge.svg)](https://github.com/xxApfelsaft/BeamMP-Linux/actions/workflows/release.yml)

**the readme is once again mostly written by ai. (i am sorry but i hate writing readmes)**

---

## Overview

Currently, BeamMP does not provide official pre-compiled binaries for Linux. Users have to set up `vcpkg`, install build dependencies, and manually compile the launcher from source.

This repository fixes that by providing:

1. **Pre-compiled Binaries** — Ready-to-run Launcher binaries via [GitHub Releases](https://github.com/xxApfelsaft/BeamMP-Linux/releases) or GitHub Actions Artifacts.
2. **Automated Build Script** — A hassle-free `build.sh` script that automatically detects your Linux distribution, installs required packages, handles `vcpkg`, and compiles the Launcher.
3. **Built-in Bug Fixes** — Standardized compilation settings (omitting Release flags) to prevent the well-known "single-server connection" bug.

---

## Quick Start — Pre-compiled Binary

If you just want to play without building anything yourself:

1. Go to the **[Releases](https://github.com/xxApfelsaft/BeamMP-Linux/releases)** page.

2. Download the latest `BeamMP-Launcher` binary.

3. Open a terminal in your download folder and make it executable:

   ```bash
   chmod +x BeamMP-Launcher
   ```

4. Run the launcher:

   ```bash
   BROWSER=/usr/bin/xdg-open ./BeamMP-Launcher
   ```

---

## Build It Yourself — Automated Script

If you prefer compiling from source on your local machine, use the included auto-build script.

### 1. Clone this repository

```bash
git clone https://github.com/xxApfelsaft/BeamMP-Linux.git
cd BeamMP-Linux
```

### 2. Make the script executable and run it

```bash
chmod +x build.sh
./build.sh
```

> **Supported Distributions for Auto-Install**
>
> - **Arch Family:** Arch Linux, Manjaro, EndeavourOS, Garuda, Artix
> - **Debian/Ubuntu Family:** Ubuntu, Debian, Pop!_OS, Linux Mint, Elementary, Zorin, Kali
> - **Fedora/RHEL Family:** Fedora, Nobara, Ultramarine, RHEL, Rocky Linux, AlmaLinux, CentOS
> - **SUSE Family:** openSUSE (Leap & Tumbleweed), SUSE
> - **Gaming & Independent:** SteamOS, Alpine, Gentoo, Void Linux, Solus, NixOS

After building, the compiled binary will be placed inside:

```text
./build_output/BeamMP-Launcher
```

---

## Troubleshooting & Tips

### Browser Not Opening Links

If the launcher fails to open login links or Discord invites, make sure your `$BROWSER` environment variable is set to your default browser or `xdg-open`:

```bash
BROWSER=/usr/bin/xdg-open ./BeamMP-Launcher
```

To make this permanent, add the following line to your `~/.bashrc` or `~/.zshrc`:

```bash
export BROWSER=/usr/bin/xdg-open
```

---

### Discord Rich Presence (RPC)

If you are running Discord via **Flatpak**, it isolates the IPC socket in `/tmp`.

Give Discord access to `/tmp` so BeamMP can read your profile:

```bash
flatpak override --filesystem=/tmp com.discordapp.Discord
```

---

## Credits & Disclaimer

* **[BeamMP](https://beammp.com/)** is developed by the BeamMP Team. All rights belong to their respective owners.
* This repository is an **unofficial community helper** designed to simplify the build process for Linux users.

---

## Contributing

Contributions, bug reports, and improvements are welcome.

Feel free to open an **Issue** or submit a **Pull Request** if you find a problem or have an idea for improving the project.
