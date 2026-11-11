#! /user/bin/env bash

# Read JSON input from stdin
input=$(cat)

# Extract rate limit data
five_hour_used=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_hour_resets_at=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
weekly_used=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
weekly_resets_at=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

# Extract model and workspace info
model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
effort=$(echo "$input" | jq -r '.effort.level // empty')
workspace=$(echo "$input" | jq -r '.workspace.current_dir // ""')

# Build status line parts
parts=()

# Add model name
if [ -n "$effort" ]; then
    parts+=("$model $effort")
else
  parts+=("$model")
fi

# Add workspace (show directory name if available)
if [ -n "$workspace" ]; then
    dir_name=$(basename "$workspace")
    parts+=("$dir_name")
fi

# Add rate limits if available
# Format: 5h: X% | 7d: Y%
if [ -n "$five_hour_used" ]; then
    part="5h: ${five_hour_used}%"

    if [ -n "five_hour_resets_at" ]; then
      part="$part ($(date -d @"$five_hour_resets_at" +%H:%M))"
    fi

    parts+=("$part")
fi
if [ -n "$weekly_used" ]; then
    part="7d: ${weekly_used}%"

    if [ -n "weekly_resets_at" ]; then
      part="$part ($(date -d @"$weekly_resets_at" '+%a %d/%m %H:%m'))"
    fi

    parts+=("$part")
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
