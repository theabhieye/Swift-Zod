#!/bin/sh
set -e

echo "→ Initializing Git hooks..."

# Go to repo root (no matter where the script is run)
REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

SOURCE_HOOK="$REPO_ROOT/.github/pre-commit"
TARGET_HOOK="$REPO_ROOT/.git/hooks/pre-commit"

# Validate source hook
if [ ! -f "$SOURCE_HOOK" ]; then
  echo "❌ Hook not found: .github/pre-commit"
  exit 1
fi

# Copy hook
cp "$SOURCE_HOOK" "$TARGET_HOOK"

# Make executable
chmod +x "$TARGET_HOOK"

echo "✔ pre-commit hook installed successfully!"
echo "→ Hook location: $TARGET_HOOK"

