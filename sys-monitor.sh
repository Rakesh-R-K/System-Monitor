#!/bin/bash

# Define log file
LOG_FILE="system_monitor.log"

# Function to create progress bars
draw_bar() {
    local usage=$1
    local length=20
    local filled=$(echo "$usage / 5" | bc)  # Convert percentage to scale of 20
    local empty=$((length - filled))
    
    echo -ne "["
    for ((i=0; i<filled; i++)); do echo -ne "█"; done
    for ((i=0; i<empty; i++)); do echo -ne " "; done
    echo -ne "]"
}

# Function to display system usage
get_usage() {
    clear  # Clear the terminal for live updates

    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
    RAM_USAGE=$(free -m | awk 'NR==2{printf "%.2f", $3*100/$2 }')
    DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

    # Save to log file
    echo "$TIMESTAMP - CPU: $CPU_USAGE%, RAM: $RAM_USAGE%, Disk: $DISK_USAGE%" >> $LOG_FILE

    # Set colors
    GREEN="\e[32m"
    YELLOW="\e[33m"
    RED="\e[31m"
    BLUE="\e[34m"
    CYAN="\e[36m"
    RESET="\e[0m"

    # Assign colors based on usage
    CPU_COLOR=$GREEN; RAM_COLOR=$GREEN; DISK_COLOR=$GREEN

    # ASCII Art Header for "SYSTEM MONITOR"
    echo -e "${CYAN}"
    echo "   _____                  __  ___            _ __            "
    echo "  / ___/__  _______      /  |/  /___  ____  (_) /_____  _____"
    echo "  \__ \/ / / / ___/_____/ /|_/ / __ \/ __ \/ / __/ __ \/ ___/"
    echo " ___/ / /_/ (__  )_____/ /  / / /_/ / / / / / /_/ /_/ / /    "
    echo "/____/\__, /____/     /_/  /_/\____/_/ /_/_/\__/\____/_/     "
    echo "     /____/                                                  "
    echo -e "${RESET}"

    echo "-------------------------------------------------"
    echo -e "🕒 Timestamp: ${YELLOW}$TIMESTAMP${RESET}"
    echo "-------------------------------------------------"
    
    echo -e "🔥 CPU Usage: ${CPU_COLOR}$CPU_USAGE%${RESET} $(draw_bar $CPU_USAGE)"
    echo -e "🟢 RAM Usage: ${RAM_COLOR}$RAM_USAGE%${RESET} $(draw_bar $RAM_USAGE)"
    echo -e "💾 Disk Usage: ${DISK_COLOR}$DISK_USAGE%${RESET} $(draw_bar $DISK_USAGE)"
    echo "-------------------------------------------------"

    echo -e "🚀 Press ${YELLOW}[CTRL+C]${RESET} to stop monitoring."
}

# Run the monitor continuously
while true; do
    get_usage
    sleep 2  # Adjust the interval as needed
done

