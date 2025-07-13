#!/bin/bash
# spotifyd setup script
set -e  # Exit on any error

USERNAME="${SUDO_USER:-$USER}"
HOME_DIR=$(eval echo "~$USERNAME")
HOSTNAME="$(cat /etc/hostname)"

# Prompt user for variant input
read -p "[INFO] Enter variant to instal (full, slim, default) [default]: " VARIANT
VARIANT="${VARIANT:-default}"  # if none use default value

# Validate input variant
case "$VARIANT" in
  full|slim|default) ;;
  *) echo "[ERROR] Unknown variant: $VARIANT. Use 'full', 'slim', or 'default'."; exit 1 ;;
esac

# Auto-detect architecture for install
UNAME_ARCH=$(uname -m)
case "$UNAME_ARCH" in
  x86_64) ARCH="x86_64" ;;
  aarch64|arm64) ARCH="aarch64" ;;
  armv7l) ARCH="armv7" ;;
  *) echo "[ERROR] Unsupported architecture: $UNAME_ARCH"; exit 1 ;;
esac

# Get latest the version
TAG=$(curl -sL https://api.github.com/repos/Spotifyd/spotifyd/releases/latest \
  | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | sed 's#^/##')

# Build archive filename
ARCHIVE_NAME="spotifyd-linux-${ARCH}-${VARIANT}.tar.gz"

# Download URL
DOWNLOAD_URL="https://github.com/Spotifyd/spotifyd/releases/download/${TAG}/${ARCHIVE_NAME}"

echo "[INFO] Downloading: $DOWNLOAD_URL"
wget "$DOWNLOAD_URL" -O "$ARCHIVE_NAME" || { echo "[ERROR] Failed to download $ARCHIVE_NAME"; exit 1; }

# Extract and install
tar xzf "$ARCHIVE_NAME"
sudo chmod +x spotifyd
sudo mv spotifyd /usr/local/bin/

# Copy config and service filep 
cp ./config/spotifyd.bus.conf spotifyd.bus.conf 
cp ./config/spotifyd.conf spotifyd.conf 
cp ./config/spotifyd.service spotifyd.service

# Define variables for config and service file
SPOTIFYD_BUS_COF="./spotifyd.bus.conf"
SPOTIFYD_CONF="./spotifyd.conf"
SPOTIFYD_SERVICE="./spotifyd.service"
sed -i "s/\bUSER\b/$USERNAME/g" "$SPOTIFYD_BUS_COF"
sed -i "s/\bDEVICE_NAME\b/$HOSTNAME/g" "$SPOTIFYD_CONF"
sed -i "s/\bUSER\b/$USERNAME/g" "$SPOTIFYD_CONF"
sed -i "s|/home/USER/|/home/$USERNAME/|g" "$SPOTIFYD_SERVICE"

mkdir -p "$HOME_DIR/.cache/spotifyd"
mkdir -p "$HOME_DIR/.config/spotifyd"
mkdir -p "$HOME_DIR/.config/systemd/user"

# Copy config to .config/spoitfyd
mv ./spotifyd.conf "$HOME_DIR/.config/spotifyd/spotifyd.conf"
mv ./spotifyd.service "$HOME_DIR/.config/systemd/user/"

# Copy bus config to /usr/share/dbus-1/system.d/
sudo mv ./spotifyd.bus.conf /usr/share/dbus-1/system.d/

# Initialize spotifyd
echo "[INFO] Initializing spotifyd for 12 seconds."
timeout 12s spotifyd --no-daemon || true

# Start spotifyd running as a service
systemctl reload dbus
systemctl --user daemon-reload
systemctl --user enable spotifyd.service --now

# Cleanup Downloaded file
rm -f "$ARCHIVE_NAME"

echo "[INFO] spotifyd ($VARIANT) for $ARCH installed from $TAG and placed in /usr/local/bin"
echo "[INFO] $(spotifyd --version)"