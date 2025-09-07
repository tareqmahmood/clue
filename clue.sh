#!/bin/bash

# clue.sh - Main script for displaying Linux command tips

CLUE_DIR="$HOME/.clue"
CONFIG_FILE="$CLUE_DIR/config.sh"

# Source configuration
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    # Default values if config doesn't exist
    CLUE_INTERVAL=5
    CLUE_MODE=beginner
    CLUE_COUNTER=0
fi

# Function to display usage
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -m <mode>     Show tip from specific mode (beg, int, adv, all)"
    echo "                Aliases: beginner, intermediate, advanced"
    echo "  -i <index>    Show specific tip by index number"
    echo "  -h, --help    Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0              # Show random tip from current mode"
    echo "  $0 -m adv       # Show random tip from advanced mode"
    echo "  $0 -m all       # Show random tip from any mode"
    echo "  $0 -i 5         # Show tip #5 from current mode"
}

# Function to normalize mode names (convert abbreviations to full names)
normalize_mode() {
    local mode="$1"
    case "$mode" in
        beg|beginner) echo "beginner" ;;
        int|intermediate) echo "intermediate" ;;
        adv|advanced) echo "advanced" ;;
        all) echo "all" ;;
        *) echo "" ;;  # Invalid mode
    esac
}

# Function to get random tip from file
get_random_tip() {
    local file="$1"
    local index="$2"
    
    if [ ! -f "$file" ]; then
        echo "Error: Tip file not found: $file"
        return 1
    fi
    
    local total_lines=$(wc -l < "$file")
    
    if [ "$total_lines" -eq 0 ]; then
        echo "Error: No tips found in $file"
        return 1
    fi
    
    if [ -n "$index" ]; then
        if [ "$index" -gt "$total_lines" ] || [ "$index" -lt 1 ]; then
            echo "Error: Index $index out of range (1-$total_lines)"
            return 1
        fi
        local line_num="$index"
        local tip_num="$index"
    else
        local line_num=$((RANDOM % total_lines + 1))
        local tip_num="$line_num"
    fi
    
    local tip_line=$(sed -n "${line_num}p" "$file")
    
    if [ -z "$tip_line" ]; then
        echo "Error: Could not read tip"
        return 1
    fi
    
    # Parse tip (format: description<|>example)
    local description=$(echo "$tip_line" | cut -d'<' -f1)
    local example=$(echo "$tip_line" | cut -d'>' -f2)
    
    # Get the mode name from filename for display
    local mode_name=$(basename "$file" .txt)
    
    # Format description with line wrapping for better readability (60 chars per line)
    local formatted_description=$(echo "$description" | fold -s -w 60)

    # Display formatted tip
    echo ""
    # Print each line in a different color
    echo -e "\033[1;36m[clue tip #$tip_num - $mode_name]\033[0m"
    echo -e "\033[1;32m$formatted_description\033[0m"
    echo ""
    echo -e "\033[1;33m$example\033[0m"
    echo ""
}

# Function to get random tip from all modes
get_random_tip_all_modes() {
    local modes=("beginner" "intermediate" "advanced")
    local random_mode=${modes[$RANDOM % ${#modes[@]}]}
    local tip_file="$CLUE_DIR/$random_mode.txt"
    
    get_random_tip "$tip_file"
}

# Main script logic
case "$1" in
    -h|--help)
        show_usage
        ;;
    -m)
        if [ -z "$2" ]; then
            echo "Error: Mode not specified"
            show_usage
            exit 1
        fi
        
        # Normalize the mode name
        normalized_mode=$(normalize_mode "$2")
        if [ -z "$normalized_mode" ]; then
            echo "Error: Invalid mode '$2'. Valid modes: beg, int, adv, all"
            echo "       Full names also supported: beginner, intermediate, advanced, all"
            exit 1
        fi
        
        case "$normalized_mode" in
            beginner|intermediate|advanced)
                tip_file="$CLUE_DIR/$normalized_mode.txt"
                get_random_tip "$tip_file"
                ;;
            all)
                get_random_tip_all_modes
                ;;
        esac
        ;;
    -i)
        if [ -z "$2" ]; then
            echo "Error: Index not specified"
            show_usage
            exit 1
        fi
        if ! [[ "$2" =~ ^[0-9]+$ ]]; then
            echo "Error: Index must be a number"
            exit 1
        fi
        
        # Normalize the current mode
        normalized_mode=$(normalize_mode "$CLUE_MODE")
        if [ -z "$normalized_mode" ]; then
            normalized_mode="beginner"  # fallback to beginner if invalid
        fi
        
        if [ "$normalized_mode" = "all" ]; then
            # For 'all' mode with index, pick a random mode first
            local modes=("beginner" "intermediate" "advanced")
            local random_mode=${modes[$RANDOM % ${#modes[@]}]}
            tip_file="$CLUE_DIR/$random_mode.txt"
        else
            tip_file="$CLUE_DIR/$normalized_mode.txt"
        fi
        get_random_tip "$tip_file" "$2"
        ;;
    "")
        # No arguments - show random tip from current mode
        # Normalize the current mode
        normalized_mode=$(normalize_mode "$CLUE_MODE")
        if [ -z "$normalized_mode" ]; then
            normalized_mode="beginner"  # fallback to beginner if invalid
        fi
        
        if [ "$normalized_mode" = "all" ]; then
            get_random_tip_all_modes
        else
            tip_file="$CLUE_DIR/$normalized_mode.txt"
            get_random_tip "$tip_file"
        fi
        ;;
    *)
        echo "Error: Unknown option '$1'"
        show_usage
        exit 1
        ;;
esac