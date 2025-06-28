#!/bin/bash
# audirvana studio or origin setup script
set -e  # Exit on any error

# Prompt user for variant input
read -p "Enter variant to instal (studio, origin) [studio]: " VARIANT
VARIANT="${VARIANT:-studio}"  # if none use studio as default value

# Validate input variant
case "$VARIANT" in
  studio|origin) ;;
  *) echo "[ERROR] Unknown variant: $VARIANT. Use 'studio' or 'origin'."; exit 1 ;;
esac

# Auto-detect architecture for install
UNAME_ARCH=$(uname -m)
case "$UNAME_ARCH" in
  x86_64) ARCH="amd64" ;;
  aarch64|arm64) ARCH="aarch64" ;;
  *) echo "[ERROR] Unsupported architecture: $UNAME_ARCH"; exit 1 ;;
esac

# Auto-detect distribution
OS=$([ -x "$(command -v apt)" ] && echo "deb" || echo "rpm")

# Download URL
DOWNLOAD_URL="https://audirvana.com/delivery/AudirvanaLinux.php?product=${VARIANT}&arch=${ARCH}&distrib=${OS}"

echo "Downloading Audirvana $VARIANT from: $DOWNLOAD_URL"

wget --content-disposition $DOWNLOAD_URL

# Installing package
sudo dpkg -i audirvana-*
/opt/audirvana/$VARIANT/setAsService.sh enable
/opt/audirvana/$VARIANT/setAsService.sh start

# Cleanup Downloaded file
rm -f audirvana-*