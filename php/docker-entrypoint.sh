#!/bin/sh
set -e

TARGET_DIR="/app/public"

if [ ! -f "$TARGET_DIR/index.php" ]; then
  echo "MODX not found, downloading version ${MODX_VERSION}..."

  mkdir -p /tmp/modx
  curl -fL "https://modx.com/download/direct/modx-${MODX_VERSION}-pl.zip" -o /tmp/modx.zip
  unzip /tmp/modx.zip -d /tmp/modx

  MODX_DIR="$(find /tmp/modx -mindepth 1 -maxdepth 1 -type d | head -n 1)"
  cp -R "${MODX_DIR}/." "$TARGET_DIR/"

  rm -rf /tmp/modx /tmp/modx.zip

  if [ -f "$TARGET_DIR/ht.access" ]; then
    mv "$TARGET_DIR/ht.access" "$TARGET_DIR/.htaccess"
  fi

  mkdir -p "$TARGET_DIR/core/cache"
  mkdir -p "$TARGET_DIR/core/config"
  mkdir -p "$TARGET_DIR/core/packages"
  mkdir -p "$TARGET_DIR/core/import"
  mkdir -p "$TARGET_DIR/core/export"

  touch "$TARGET_DIR/core/config/config.inc.php"

  chown -R www-data:www-data "$TARGET_DIR"
  find "$TARGET_DIR" -type d -exec chmod 755 {} \;
  find "$TARGET_DIR" -type f -exec chmod 644 {} \;

  chmod -R 775 "$TARGET_DIR/core/cache"
  chmod -R 775 "$TARGET_DIR/core/config"
  chmod -R 775 "$TARGET_DIR/core/packages"
  chmod -R 775 "$TARGET_DIR/core/import"
  chmod -R 775 "$TARGET_DIR/core/export"
  chmod 664 "$TARGET_DIR/core/config/config.inc.php"

  echo "MODX downloaded and prepared."
fi

exec "$@"