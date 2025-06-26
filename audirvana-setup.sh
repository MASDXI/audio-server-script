#!/bin/bash
# audirvana studio setup script
set -e  # Exit on any error

# Prompt user for variant input
read -p "Enter variant to instal (studio, origin) [studio]: " VARIANT
VARIANT="${VARIANT:-studio}"  # if none use studio as default value

# Validate input variant
case "$VARIANT" in
  studio|origin) ;;
  *) echo "[ERROR] Unknown variant: $VARIANT. Use 'studio' or 'origin'."; exit 1 ;;
esac

# Auto-detect architecture for install x86_64 or aarch64
# TODO

# Auto-detect operating system deb or rpm
# TODO

# Get latest the version
# TODO

# Build archive filename
# TODO

# Download URL
# TODO

# Install
# TODO

# Cleanup Downloaded file
# TODO