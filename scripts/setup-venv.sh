#!/bin/bash
# Setup Python virtual environment
# Run this once per worktree or new machine

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

echo "Setting up Python venv in $PROJECT_DIR..."

# Check Python version
PYTHON_VERSION=$(python3 --version 2>&1 | cut -d' ' -f2 | cut -d'.' -f1,2)
REQUIRED_VERSION="3.11"

if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$PYTHON_VERSION" | sort -V | head -n1)" != "$REQUIRED_VERSION" ]; then
    echo "Error: Python >= $REQUIRED_VERSION required, found $PYTHON_VERSION"
    exit 1
fi

# Create venv if it doesn't exist
if [ ! -d ".venv" ]; then
    echo "Creating .venv..."
    python3 -m venv .venv
else
    echo ".venv already exists"
fi

# Activate and install
echo "Activating venv and installing dependencies..."
source .venv/bin/activate
pip install --upgrade pip

# Install project dependencies if pyproject.toml exists
if [ -f "pyproject.toml" ]; then
    pip install -e ".[dev]"
else
    echo "No pyproject.toml found - skipping dependency install"
    echo "Add your dependencies to pyproject.toml and run: pip install -e '.[dev]'"
fi

echo ""
echo "Setup complete!"
echo ""
echo "To activate the venv, run:"
echo "  source .venv/bin/activate"
