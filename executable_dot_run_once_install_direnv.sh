if ! command -v direnv >/dev/null 2>&1; then
  echo "Installing direnv..."
  curl -sfL https://direnv.net/install.sh | bash
fi
