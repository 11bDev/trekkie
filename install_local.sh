#!/bin/bash

# Trekkie Local Installation Script (for current user only)

set -e

echo "Installing Trekkie locally for current user..."

# Build the application
echo "Building application..."
flutter build linux --release

# Create local installation directories
LOCAL_DIR="$HOME/.local/share/trekkie"
DESKTOP_FILE="$HOME/.local/share/applications/com.example.trekkie.desktop"
ICON_DIR="$HOME/.local/share/icons/hicolor"

echo "Creating local installation directories..."
mkdir -p "$LOCAL_DIR"
mkdir -p "$HOME/.local/share/applications"
mkdir -p "$ICON_DIR"/{16x16,32x32,48x48,64x64,128x128,256x256,512x512}/apps

# Copy application files
echo "Installing application files..."
cp -r build/linux/x64/release/bundle/* "$LOCAL_DIR/"

# Install desktop file
echo "Installing desktop entry..."
cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Trekkie
Comment=Star Trek Timeline Tracker - Track your journey through the Star Trek universe
Exec=$LOCAL_DIR/trekkie
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
        cp "linux/icons/hicolor/$size/apps/trekkie.png" "$ICON_DIR/$size/apps/"
    fi
done

# Create local bin symlink if ~/.local/bin exists
if [ -d "$HOME/.local/bin" ]; then
    echo "Creating local command line symlink..."
    ln -sf "$LOCAL_DIR/trekkie" "$HOME/.local/bin/trekkie"
fi

# Update desktop database and icon cache for user
echo "Updating desktop database..."
update-desktop-database "$HOME/.local/share/applications/" 2>/dev/null || true
gtk-update-icon-cache -f -t "$HOME/.local/share/icons/hicolor/" 2>/dev/null || true

echo "Local installation complete!"
echo "You can now:"
echo "  - Launch Trekkie from your application menu"
if [ -d "$HOME/.local/bin" ]; then
    echo "  - Run 'trekkie' from the command line (if ~/.local/bin is in your PATH)"
fi
echo "  - Find it in your desktop environment's application launcher"
echo ""
echo "The Star Trek delta icon should now appear in your panel and application menu."