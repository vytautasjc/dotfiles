#!/bin/bash
# Claude Code status line
# Format: <Model> | ctx: <pct>% | <used>k/<total>k | 5h: <pct>% T-<time> | 7d: <pct>% T-<time>
# Example: Opus 4.7 high | ctx: 47.2% | 94.4k/200k | 5h: 32% T-20m38s | 7d: 18% T-23h44m

CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"

BOLD='\033[1m'
RESET='\033[0m'

input=$(cat)

# Model
MODEL=$(echo "$input" | jq -r '.model.display_name // "Unknown"')

# Context window
CTX_PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
CTX_SIZE=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')
CTX_USED=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')

# Format token counts: show as k with one decimal, or M for >=1M
fmt_tokens() {
  local n=$1
  if [ "$n" -ge 1000000 ] 2>/dev/null; then
    echo "$(echo "scale=1; $n / 1000000" | bc)M"
  elif [ "$n" -ge 1000 ] 2>/dev/null; then
    echo "$(echo "scale=1; $n / 1000" | bc)k"
  else
    echo "${n}"
  fi
}

USED_FMT=$(fmt_tokens "$CTX_USED")
TOTAL_FMT=$(fmt_tokens "$CTX_SIZE")

# Rate limit time till reset helper: seconds → T-XdYh,T-XhYm T-XmYs 
fmt_duration() {
  local secs=$1
  if [ "$secs" -le 0 ] 2>/dev/null; then
    echo "T-0s"
    return
  fi
  local d=$((secs / 86400))
  local h=$(( (secs % 86400) / 3600 ))
  local m=$(( (secs % 3600) / 60 ))
  local s=$((secs % 60))
  if [ "$d" -gt 0 ]; then
    echo "T-${d}d${h}h"
  elif [ "$h" -gt 0 ]; then
    echo "T-${h}h${m}m"
  else
    echo "T-${m}m${s}s"
  fi
}

# 5-hour rate limit
FIVE_H_PCT=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
FIVE_H_RESETS=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')

if [ -n "$FIVE_H_PCT" ] && [ -n "$FIVE_H_RESETS" ]; then
  NOW=$(date +%s)
  FIVE_H_SECS=$(( FIVE_H_RESETS - NOW ))
  FIVE_H_TIME=$(fmt_duration "$FIVE_H_SECS")
  FIVE_H_INT=$(printf "%.0f" "$FIVE_H_PCT")
  FIVE_H_STR="${FIVE_H_INT}% ${FIVE_H_TIME}"
else
  FIVE_H_STR="N/A"
fi

# 7-day rate limit
SEVEN_D_PCT=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
SEVEN_D_RESETS=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

if [ -n "$SEVEN_D_PCT" ] && [ -n "$SEVEN_D_RESETS" ]; then
  NOW=$(date +%s)
  SEVEN_D_SECS=$(( SEVEN_D_RESETS - NOW ))
  SEVEN_D_TIME=$(fmt_duration "$SEVEN_D_SECS")
  SEVEN_D_INT=$(printf "%.0f" "$SEVEN_D_PCT")
  SEVEN_D_STR="${SEVEN_D_INT}% ${SEVEN_D_TIME}"
else
  SEVEN_D_STR="N/A"
fi

# Session cost
COST_USD=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
COST_STR=$(printf "\$%.2f" "$COST_USD")

# Format ctx percentage to one decimal
CTX_PCT_FMT=$(printf "%.1f" "$CTX_PCT")

echo -e "${BOLD}${MODEL}${RESET} | ${BOLD}ctx:${RESET} ${CTX_PCT_FMT}% | ${USED_FMT}/${TOTAL_FMT} | ${BOLD}5h:${RESET} ${FIVE_H_STR} | ${BOLD}7d:${RESET} ${SEVEN_D_STR} | ${BOLD}Cost:${RESET} ${COST_STR}"