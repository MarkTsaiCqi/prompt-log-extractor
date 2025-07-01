#!/bin/bash

RESET="\033[0m"
BLUE="\033[1;34m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
MAGENTA="\033[1;35m"
CYAN="\033[1;36m"
RED="\033[1;31m"

block=""
in_prompt=0

while IFS= read -r line; do
  block+="$line"$'\n'

  if echo "$line" | grep -q "Selected prompts in order"; then
    timestamp=$(echo "$line" | awk '{print $1, $2}' | cut -d',' -f1)
    analysis=$(echo "$block" | grep "analysis=" | tail -1 | sed -E "s/.*analysis='([^']*)'.*/\1/")
    targets=$(echo "$block" | grep "targets=" | tail -1 | sed -E "s/.*targets=\[(.*?)]/\1/" | sed 's/\]\s*selected_prompts=.*//; s/\s*selected_prompts=.*//')
    selected=$(echo "$block" | grep "selected_prompts=" | tail -1 | sed -E "s/.*selected_prompts=\[(.*?)\].*/[\1]/")
    prompts=$(echo "$line" | grep -oP "Selected prompts in order:\s*\[\K[^\]]+" | tr -d "'" | tr '\n' ' ' | sed 's/, targets//g')
    echo -e "${CYAN}--- PROMPT ENTRY --- [$timestamp]${RESET}"
    echo -e "${BLUE}analysis:${RESET} $analysis"
    echo -e "${GREEN}targets:${RESET} [$targets]"
    echo -e "${YELLOW}selected_prompts:${RESET} $selected"
    echo -e "${MAGENTA}Selected prompts in order:${RESET} $prompts"
    echo

    in_prompt=1
    block=""
    continue
  fi

  if [[ $in_prompt -eq 1 ]]; then
    # 抓五種 call
    if echo "$line" | grep -q -E "Tool call:|MCP call:|Power call:|Agent to agent call:|Special signal call:"; then
      echo -e "${RED}--- CALL DETECTED --- [$timestamp]${RESET}"
      echo "$line"
      echo -e "${RED}--- END CALL ---${RESET}\n"
      in_prompt=0
      block=""
    fi
  fi

done
