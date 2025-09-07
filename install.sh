#!/bin/bash

# clue - Linux command line tips utility
# Setup script

set -e

CLUE_DIR="$HOME/.clue"
BASE_URL="https://tareqmahmood.github.io/clue"
LOCAL_MODE=false

# Check for local mode
if [ "$1" = "local" ]; then
    LOCAL_MODE=true
    echo "Running in local mode - using files from current directory"
else
    echo "Running in download mode - fetching files from $BASE_URL"
fi

echo "Setting up clue utility..."

# Create clue directory if it doesn't exist
if [ ! -d "$CLUE_DIR" ]; then
    echo "Creating $CLUE_DIR directory..."
    mkdir -p "$CLUE_DIR"
fi

# Download main script
echo "Installing clue.sh..."
if [ "$LOCAL_MODE" = true ]; then
    if [ -f "./clue.sh" ]; then
        cp "./clue.sh" "$CLUE_DIR/clue.sh"
        chmod +x "$CLUE_DIR/clue.sh"
    else
        echo "Error: clue.sh not found in current directory"
        exit 1
    fi
else
    curl -s "$BASE_URL/clue.sh" -o "$CLUE_DIR/clue.sh"
    chmod +x "$CLUE_DIR/clue.sh"
fi

# Download tip files
echo "Installing tip files..."
for file in beginner.txt intermediate.txt advanced.txt; do
    if [ "$LOCAL_MODE" = true ]; then
        if [ -f "./$file" ]; then
            cp "./$file" "$CLUE_DIR/$file"
        else
            echo "Error: $file not found in current directory"
            exit 1
        fi
    else
        curl -s "$BASE_URL/$file" -o "$CLUE_DIR/$file"
    fi
done

# Download uninstall script
echo "Installing uninstall script..."
if [ "$LOCAL_MODE" = true ]; then
    if [ -f "./uninstall.sh" ]; then
        cp "./uninstall.sh" "$CLUE_DIR/uninstall.sh"
        chmod +x "$CLUE_DIR/uninstall.sh"
    else
        echo "Warning: uninstall.sh not found in current directory"
    fi
else
    curl -s "$BASE_URL/uninstall.sh" -o "$CLUE_DIR/uninstall.sh"
    chmod +x "$CLUE_DIR/uninstall.sh"
fi

# Download config.sh only if it doesn't exist (preserve user settings)
if [ ! -f "$CLUE_DIR/config.sh" ]; then
    echo "Installing default config.sh..."
    if [ "$LOCAL_MODE" = true ]; then
        if [ -f "./config.sh" ]; then
            cp "./config.sh" "$CLUE_DIR/config.sh"
        else
            echo "Error: config.sh not found in current directory"
            exit 1
        fi
    else
        curl -s "$BASE_URL/config.sh" -o "$CLUE_DIR/config.sh"
    fi
else
    echo "config.sh already exists, keeping current settings..."
fi

# Modify .bashrc to integrate clue
BASHRC="$HOME/.bashrc"
CLUE_INTEGRATION="# BEGIN CLUE INTEGRATION - DO NOT EDIT THIS BLOCK MANUALLY
# clue - Linux command line tips utility
# This block was automatically added by clue setup
if [ -f \$HOME/.clue/config.sh ]; then
    source \$HOME/.clue/config.sh
    
    # Initialize counter if not set
    if [ -z \"\$CLUE_COUNTER\" ]; then
        CLUE_COUNTER=0
    fi
    
    # Function to run clue after each command
    clue_prompt_command() {
        if [ -f \$HOME/.clue/clue.sh ]; then
            # Increment counter
            CLUE_COUNTER=\$((CLUE_COUNTER + 1))
            
            # Show tip every CLUE_INTERVAL commands
            if [ \$((CLUE_COUNTER % CLUE_INTERVAL)) -eq 0 ]; then
                \$HOME/.clue/clue.sh -m \$CLUE_MODE
            fi
        fi
    }
    
    # Add to PROMPT_COMMAND
    if [[ \"\$PROMPT_COMMAND\" != *\"clue_prompt_command\"* ]]; then
        PROMPT_COMMAND=\"clue_prompt_command;\$PROMPT_COMMAND\"
    fi

    # Add a clue alias for manual tip viewing
    alias clue='\$HOME/.clue/clue.sh'
fi
# END CLUE INTEGRATION"

# Check if clue integration already exists in .bashrc
if ! grep -q "# BEGIN CLUE INTEGRATION" "$BASHRC" 2>/dev/null; then
    echo "Adding clue integration to .bashrc..."
    echo "" >> "$BASHRC"
    echo "$CLUE_INTEGRATION" >> "$BASHRC"
    echo "Added clue integration to .bashrc"
else
    echo "clue integration already exists in .bashrc"
fi

echo "Setup complete!"
if [ "$LOCAL_MODE" = true ]; then
    echo "Installed clue from local files in current directory."
else
    echo "Downloaded and installed clue from $BASE_URL"
fi
echo "You can also run '$CLUE_DIR/clue.sh' manually to see a tip."
echo "To uninstall clue later, run: $CLUE_DIR/uninstall.sh"
echo ""
echo "Please run 'source ~/.bashrc' or restart your terminal to activate clue."
