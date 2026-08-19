#!/usr/bin/env bash
set -e

echo "BeamMP Launcher Linux Buildscript. github.com/xxApfelsaft/BeamMP-Linux"

DISTRO="unknown"
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
    DISTRO_LIKE=$ID_LIKE
fi

echo "==> Detected distribution: $DISTRO (family: ${DISTRO_LIKE:-none})"
echo "==> Installing build dependencies (sudo required)..."

# Detect pkg manager / distro
if [[ "$DISTRO" =~ ^(arch|manjaro|endeavouros|garuda|artix)$ ]] || [[ "$DISTRO_LIKE" =~ "arch" ]]; then
    sudo pacman -S --needed --noconfirm base-devel cmake git perl

elif [[ "$DISTRO" =~ ^(ubuntu|debian|pop|mint|elementary|zorin|kali)$ ]] || [[ "$DISTRO_LIKE" =~ "debian" ]] || [[ "$DISTRO_LIKE" =~ "ubuntu" ]]; then
    sudo apt update
    sudo apt install -y build-essential cmake git perl

elif [[ "$DISTRO" =~ ^(fedora|nobara|ultramarine)$ ]]; then
    sudo dnf install -y cmake gcc gcc-c++ make perl perl-IPC-Cmd perl-FindBin perl-File-Compare perl-File-Copy kernel-headers kernel-devel

elif [[ "$DISTRO" =~ ^(rhel|rocky|almalinux|centos)$ ]] || [[ "$DISTRO_LIKE" =~ "rhel" ]]; then
    sudo dnf groupinstall -y "Development Tools"
    sudo dnf install -y cmake git perl perl-IPC-Cmd perl-FindBin perl-File-Compare perl-File-Copy

elif [[ "$DISTRO" =~ ^(opensuse-leap|opensuse-tumbleweed|suse)$ ]] || [[ "$DISTRO_LIKE" =~ "suse" ]]; then
    sudo zypper in -y -t pattern devel-basis
    sudo zypper in -y cmake git perl

elif [ "$DISTRO" = "steamos" ]; then
    echo "SteamOS detected! Ensure 'sudo steamos-readonly disable' has been executed."
    sudo pacman -S --needed --noconfirm base-devel linux-api-headers glibc libconfig cmake git perl

elif [ "$DISTRO" = "alpine" ]; then
    sudo apk add build-base cmake git perl linux-headers

elif [ "$DISTRO" = "gentoo" ]; then
    sudo emerge --ask=n dev-build/cmake dev-vcs/git dev-lang/perl

elif [ "$DISTRO" = "void" ]; then
    sudo xbps-install -Sy base-devel cmake git perl

elif [ "$DISTRO" = "solus" ]; then
    sudo eopkg it -y -c system.devel
    sudo eopkg it -y cmake git perl

elif [ "$DISTRO" = "nixos" ]; then
    echo "NixOS detected. Please run this script inside a nix-shell with cmake, gcc, git, and perl."

else
    echo "Warning: Unrecognized distro ($DISTRO). Please ensure base-devel/build-essential, cmake, git, and perl are installed."
fi

# vcpkg
if [ ! -d "vcpkg" ]; then
    echo "==> Cloning vcpkg..."
    git clone https://github.com/microsoft/vcpkg.git
    ./vcpkg/bootstrap-vcpkg.sh
fi

export VCPKG_ROOT="$(pwd)/vcpkg"
export PATH=$VCPKG_ROOT:$PATH

# Clone BeamMP Launcher
if [ ! -d "BeamMP-Launcher" ]; then
    echo "==> Cloning BeamMP-Launcher..."
    git clone https://github.com/BeamMP/BeamMP-Launcher.git
fi

cd BeamMP-Launcher

LATEST_TAG=$(git describe --tags $(git rev-list --tags --max-count=1))
echo "==> Checking out latest tag: $LATEST_TAG"
git checkout $LATEST_TAG

echo "==> Configuring and Building..."
cmake . -B bin -DCMAKE_TOOLCHAIN_FILE=$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake -DVCPKG_TARGET_TRIPLET=x64-linux
cmake --build bin --parallel

cd ..
mkdir -p build_output
cp BeamMP-Launcher/bin/BeamMP-Launcher build_output/

echo "------------------------------------------------------"
echo "Done. Executable location: ./build_output/BeamMP-Launcher"
echo "Run with: BROWSER=/usr/bin/xdg-open ./build_output/BeamMP-Launcher"
echo "------------------------------------------------------"
