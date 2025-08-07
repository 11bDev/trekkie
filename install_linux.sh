#!/bin/bash

# Trekkie Linux Installation Script

set -e

echo "Installing Trekkie for Linux..."

# Build the application
echo "Building application..."
flutter build linux --release

# Create installation directories
INSTALL_DIR="/opt/trekkie"
DESKTOP_FILE="/usr/share/applications/com.example.trekkie.desktop"
ICON_DIR="/usr/share/icons/hicolor"

echo "Creating installation directories..."
sudo mkdir -p "$INSTALL_DIR"
sudo mkdir -p "/usr/share/applications"
sudo mkdir -p "$ICON_DIR"/{16x16,32x32,48x48,64x64,128x128,256x256,512x512}/apps

# Copy application files
echo "Installing application files..."
sudo cp -r build/linux/x64/release/bundle/* "$INSTALL_DIR/"

# Install desktop file
echo "Installing desktop entry..."
sudo tee "$DESKTOP_FILE" > /dev/null << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Trekkie
Comment=Star Trek Timeline Tracker - Track your journey through the Star Trek universe
Exec=$INSTALL_DIR/trekkie
Icon=trekkie
Terminal=false
Categories=AudioVideo;Video;Player;Entertainment;
StartupNotify=true
StartupWMClass=trekkie
Keywords=star trek;timeline;episodes;movies;tracker;sci-fi;
EOF

# Install icons
echo "Installing application icons..."
for size in 16x16 32x32 48x48 64x64 128x128 256x256 512x512; do
    if [ -f "linux/icons/hicolor/$size/apps/trekkie.png" ]; then
        sudo cp "linux/icons/hicolor/$size/apps/trekkie.png" "$ICON_DIR/$size/apps/"
    fi
done

# Create symlink for command line access
echo "Creating command line symlink..."
sudo ln -sf "$INSTALL_DIR/trekkie" "/usr/local/bin/trekkie"

# Update desktop database and icon cache
echo "Updating desktop database..."
sudo update-desktop-database /usr/share/applications/ 2>/dev/null || true
sudo gtk-update-icon-cache -f -t /usr/share/icons/hicolor/ 2>/dev/null || true

echo "Installation complete!"
echo "You can now:"
echo "  - Launch Trekkie from your application menu"
echo "  - Run 'trekkie' from the command line"
echo "  - Find it in your desktop environment's application launcher"
echo ""
echo "The Star Trek delta icon should now appear in your panel and application menu."