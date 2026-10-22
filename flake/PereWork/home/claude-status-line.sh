#! /user/bin/env bash

# Read JSON input from stdin
input=$(cat)

# Extract rate limit data
five_hour_used=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
weekly_used=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

# Extract model and workspace info
model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
workspace=$(echo "$input" | jq -r '.workspace.current_dir // ""')

# Build status line parts
parts=()

# Add model name
parts+=("$model")

# Add workspace (show directory name if available)
if [ -n "$workspace" ]; then
    dir_name=$(basename "$workspace")
    parts+=("$dir_name")
fi

# Add rate limits if available
# Format: 5h: X% | 7d: Y%
if [ -n "$five_hour_used" ]; then
    parts+=("5h: ${five_hour_used}%")
fi
if [ -n "$weekly_used" ]; then
    parts+=("7d: ${weekly_used}%")
fi

# Join parts with " | "
status=""
for i in "${!parts[@]}"; do
    if [ "$i" -eq 0 ]; then
        status="${parts[$i]}"
    else
        status="$status | ${parts[$i]}"
    fi
done

echo "$status"
