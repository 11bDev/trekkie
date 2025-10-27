#!/bin/bash

# Script to create a DEB package for Trekkie app

VERSION="1.1.0"
PACKAGE_NAME="trekkie"
ARCH="amd64"
BUILD_DIR="build/linux/x64/release/bundle"
DEB_DIR="build/deb"
PACKAGE_DIR="${DEB_DIR}/${PACKAGE_NAME}_${VERSION}_${ARCH}"

echo "Creating DEB package for ${PACKAGE_NAME} v${VERSION}..."

# Clean previous build
rm -rf "${DEB_DIR}"

# Create directory structure
mkdir -p "${PACKAGE_DIR}/DEBIAN"
mkdir -p "${PACKAGE_DIR}/opt/${PACKAGE_NAME}"
mkdir -p "${PACKAGE_DIR}/usr/share/applications"
mkdir -p "${PACKAGE_DIR}/usr/share/icons/hicolor/512x512/apps"

# Copy application files
echo "Copying application files..."
cp -r "${BUILD_DIR}"/* "${PACKAGE_DIR}/opt/${PACKAGE_NAME}/"

# Copy icon
if [ -f "linux/icons/hicolor/512x512/apps/com.example.trekkie.png" ]; then
    cp "linux/icons/hicolor/512x512/apps/com.example.trekkie.png" \
       "${PACKAGE_DIR}/usr/share/icons/hicolor/512x512/apps/${PACKAGE_NAME}.png"
fi

# Create control file
cat > "${PACKAGE_DIR}/DEBIAN/control" << EOF
Package: ${PACKAGE_NAME}
Version: ${VERSION}
Section: utils
Priority: optional
Architecture: ${ARCH}
Maintainer: Trekkie Development Team <trekkie@example.com>
Description: The Ultimate Star Trek Timeline Tracker
 Watch 900+ episodes and 14 movies in proper chronological order.
 .
 Features:
  - Complete Star Trek episode database (900+ episodes)
  - All 14 Star Trek movies
  - Chronological viewing order organized into 6 eras
  - Watch tracking with timestamps
  - Favorites system for episodes and movies
  - Progress tracking with visual indicators
  - Statistics dashboard
  - Smart navigation from recommended viewing order
Depends: libgtk-3-0, libblkid1, liblzma5
EOF

# Create desktop file
cat > "${PACKAGE_DIR}/usr/share/applications/${PACKAGE_NAME}.desktop" << EOF
[Desktop Entry]
Name=Trekkie
Comment=The Ultimate Star Trek Timeline Tracker
Exec=/opt/${PACKAGE_NAME}/trekkie
Icon=${PACKAGE_NAME}
Terminal=false
Type=Application
Categories=Utility;Education;
Keywords=star trek;timeline;tracker;episodes;movies;
StartupWMClass=trekkie
EOF

# Create postinst script
cat > "${PACKAGE_DIR}/DEBIAN/postinst" << EOF
#!/bin/bash
set -e

# Update desktop database
if command -v update-desktop-database > /dev/null 2>&1; then
    update-desktop-database -q
fi

# Update icon cache
if command -v gtk-update-icon-cache > /dev/null 2>&1; then
    gtk-update-icon-cache -q /usr/share/icons/hicolor || true
fi

exit 0
EOF

chmod 755 "${PACKAGE_DIR}/DEBIAN/postinst"

# Create postrm script
cat > "${PACKAGE_DIR}/DEBIAN/postrm" << EOF
#!/bin/bash
set -e

# Update desktop database
if command -v update-desktop-database > /dev/null 2>&1; then
    update-desktop-database -q
fi

# Update icon cache
if command -v gtk-update-icon-cache > /dev/null 2>&1; then
    gtk-update-icon-cache -q /usr/share/icons/hicolor || true
fi

exit 0
EOF

chmod 755 "${PACKAGE_DIR}/DEBIAN/postrm"

# Set permissions
echo "Setting permissions..."
chmod -R 755 "${PACKAGE_DIR}/opt/${PACKAGE_NAME}"
find "${PACKAGE_DIR}" -type f -name "*.so*" -exec chmod 644 {} \;
chmod 755 "${PACKAGE_DIR}/opt/${PACKAGE_NAME}/trekkie"

# Build the DEB package
echo "Building DEB package..."
dpkg-deb --build "${PACKAGE_DIR}"

# Move to build directory
mv "${PACKAGE_DIR}.deb" "${DEB_DIR}/"

echo "✓ DEB package created: ${DEB_DIR}/${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"
echo ""
echo "Install with: sudo dpkg -i ${DEB_DIR}/${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"
