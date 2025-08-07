#!/bin/bash

# Refresh Desktop Integration Script

echo "Refreshing desktop database and icon cache..."

# Update user desktop database
if [ -d "$HOME/.local/share/applications" ]; then
    echo "Updating user desktop database..."
    update-desktop-database "$HOME/.local/share/applications/" 2>/dev/null || true
fi

# Update user icon cache
if [ -d "$HOME/.local/share/icons/hicolor" ]; then
    echo "Updating user icon cache..."
    gtk-update-icon-cache -f -t "$HOME/.local/share/icons/hicolor/" 2>/dev/null || true
fi

# Update system desktop database (if we have permissions)
if [ -w "/usr/share/applications" ]; then
    echo "Updating system desktop database..."
    sudo update-desktop-database /usr/share/applications/ 2>/dev/null || true
fi

# Update system icon cache (if we have permissions)
if [ -w "/usr/share/icons/hicolor" ]; then
    echo "Updating system icon cache..."
    sudo gtk-update-icon-cache -f -t /usr/share/icons/hicolor/ 2>/dev/null || true
fi

echo "Desktop refresh complete!"
echo "The Trekkie icon should now appear properly in your desktop environment."