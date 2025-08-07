#!/bin/bash

# Trekkie Linux Uninstallation Script

set -e

echo "Uninstalling Trekkie from Linux..."

# Remove application files
echo "Removing application files..."
sudo rm -rf "/opt/trekkie"

# Remove desktop file
echo "Removing desktop entry..."
sudo rm -f "/usr/share/applications/com.example.trekkie.desktop"

# Remove icons
echo "Removing application icons..."
for size in 16x16 32x32 48x48 64x64 128x128 256x256 512x512; do
    sudo rm -f "/usr/share/icons/hicolor/$size/apps/trekkie.png"
done

# Remove command line symlink
echo "Removing command line symlink..."
sudo rm -f "/usr/local/bin/trekkie"

# Update desktop database and icon cache
echo "Updating desktop database..."
sudo update-desktop-database /usr/share/applications/ 2>/dev/null || true
sudo gtk-update-icon-cache -f -t /usr/share/icons/hicolor/ 2>/dev/null || true

echo "Uninstallation complete!"
echo "Trekkie has been removed from your system."