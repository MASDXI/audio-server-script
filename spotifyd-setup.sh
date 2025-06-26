#!/bin/bash
# spotifyd setup script
set -e  # Exit on any error

# Prompt user for variant input
read -p "Enter variant to instal (full, slim, default) [default]: " VARIANT
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
  | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

# Build archive filename
ARCHIVE_NAME="spotifyd-linux-${ARCH}-${VARIANT}.tar.gz"

# Download URL
DOWNLOAD_URL="https://github.com/Spotifyd/spotifyd/releases/download/${TAG}/${ARCHIVE_NAME}"

echo "Downloading: $DOWNLOAD_URL"
wget "$DOWNLOAD_URL" -O "$ARCHIVE_NAME" || { echo "[ERROR] Failed to download $ARCHIVE_NAME"; exit 1; }

# # Extract and install
# tar xzf "$ARCHIVE_NAME"
# sudo mv spotifyd /usr/local/bin/
# sudo chmod +x /usr/local/bin/spotifyd

# # Cleanup tar
# rm -f "$ARCHIVE_NAME"

echo "spotifyd ($VARIANT) for $ARCH installed from $TAG and placed in /usr/local/bin"
