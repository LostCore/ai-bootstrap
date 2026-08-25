#!/bin/bash
#
# Claude Code statusline command.
# Line 1 mirrors the colored PS1 defined in ~/.bashrc:
#   PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#
# Mapping used:
#   \u  -> $(whoami)
#   \h  -> $(hostname -s)
#   \w  -> current directory reported by Claude Code (workspace.current_dir)
#   \$  -> dropped (trailing "$"/">" must not appear in the statusline)
#   debian_chroot prefix -> kept, shown only if $debian_chroot is set
#
# Line 2 adds usage info: model, context window bar, session cost/duration,
# and Claude.ai 5h/7d rate-limit usage (when available).

input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir')

user=$(whoami)
host=$(hostname -s)

chroot_part=""
if [ -n "$debian_chroot" ]; then
  chroot_part="($debian_chroot)"
fi

printf '%s\033[01;32m%s@%s\033[00m:\033[01;34m%s\033[00m\n' "$chroot_part" "$user" "$host" "$cwd"

# --- Line 2: usage info ---

MODEL=$(echo "$input" | jq -r '.model.display_name')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
DURATION_MS=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')
FIVE_H=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
WEEK=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
CYAN='\033[36m'
RESET='\033[0m'

if [ "$PCT" -ge 90 ]; then BAR_COLOR="$RED"
elif [ "$PCT" -ge 70 ]; then BAR_COLOR="$YELLOW"
else BAR_COLOR="$GREEN"; fi

BAR_WIDTH=10
FILLED=$((PCT * BAR_WIDTH / 100))
EMPTY=$((BAR_WIDTH - FILLED))
BAR=""
[ "$FILLED" -gt 0 ] && printf -v FILL "%${FILLED}s" && BAR="${FILL// /█}"
[ "$EMPTY" -gt 0 ] && printf -v PAD "%${EMPTY}s" && BAR="${BAR}${PAD// /░}"

COST_FMT=$(printf '$%.2f' "$COST")
DURATION_SEC=$((DURATION_MS / 1000))
MINS=$((DURATION_SEC / 60))
SECS=$((DURATION_SEC % 60))

LIMITS=""
[ -n "$FIVE_H" ] && LIMITS="5h:$(printf '%.0f' "$FIVE_H")%"
[ -n "$WEEK" ] && LIMITS="${LIMITS:+$LIMITS }7d:$(printf '%.0f' "$WEEK")%"

printf "${CYAN}[%s]${RESET} ${BAR_COLOR}%s${RESET} %s%% | %s | %sm%ss" "$MODEL" "$BAR" "$PCT" "$COST_FMT" "$MINS" "$SECS"
[ -n "$LIMITS" ] && printf " | %s" "$LIMITS"
