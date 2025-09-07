#!/bin/bash

# uninstall.sh - Clean uninstall script for clue utility

set -e

CLUE_DIR="$HOME/.clue"
BASHRC="$HOME/.bashrc"

echo "Uninstalling clue utility..."

# Function to remove clue integration from .bashrc
remove_bashrc_integration() {
    if [ -f "$BASHRC" ]; then
        if grep -q "# BEGIN CLUE INTEGRATION" "$BASHRC"; then
            echo "Removing clue integration from .bashrc..."
            
            # Create a backup of .bashrc
            cp "$BASHRC" "${BASHRC}.clue-backup"
            echo "Created backup: ${BASHRC}.clue-backup"
            
            # Remove the clue integration block
            sed -i '/# BEGIN CLUE INTEGRATION/,/# END CLUE INTEGRATION/d' "$BASHRC"
            
            # Remove any empty lines that were left behind
            sed -i '/^$/N;/^\n$/d' "$BASHRC"
            
            echo "Removed clue integration from .bashrc"
        else
            echo "No clue integration found in .bashrc"
        fi
    else
        echo ".bashrc not found"
    fi
}

# Function to remove clue directory and files
remove_clue_files() {
    if [ -d "$CLUE_DIR" ]; then
        echo "Removing clue directory: $CLUE_DIR"
        rm -rf "$CLUE_DIR"
        echo "Removed clue files"
    else
        echo "Clue directory not found: $CLUE_DIR"
    fi
}

# Main uninstall process
echo "This will completely remove clue from your system."
read -p "Are you sure you want to continue? (y/N): " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    remove_bashrc_integration
    remove_clue_files
    
    echo ""
    echo "Uninstall complete!"
    echo "If you want to restore your original .bashrc, use:"
    echo "  mv ~/.bashrc.clue-backup ~/.bashrc"
    echo ""
    echo "Please restart your terminal"
else
    echo "Uninstall cancelled."
    exit 0
fi