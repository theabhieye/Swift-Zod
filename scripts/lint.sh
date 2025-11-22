#!/bin/sh

echo "→ Running SwiftLint..."
if command -v swiftlint >/dev/null 2>&1; then
  swiftlint
else
  echo "SwiftLint not installed. Install via: brew install swiftlint"
  exit 1
fi
