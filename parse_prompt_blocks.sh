#!/bin/bash

RESET="\033[0m"
CYAN="\033[1;36m"
BLUE="\033[1;34m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
MAGENTA="\033[1;35m"
RED="\033[1;31m"

block=""
timestamp=""
callblock=""
in_call=0

while IFS= read -r line; do
  block+="$line"$'\n'

  # PROMPT
  if echo "$line" | grep -q "Selected prompts in order:"; then
    timestamp=$(echo "$line" | awk '{print $1, $2}' | cut -d',' -f1)
    prompts=$(echo "$line" | sed -E "s/.*Selected prompts in order: \[(.*)\]/\1/" | tr -d "'")
    echo -e "${CYAN}--- PROMPT ENTRY --- [$timestamp]${RESET}"
    echo -e "${BLUE}Selected prompts in order:${RESET} $prompts"
  fi

  if echo "$line" | grep -q "Selected tools must use:"; then
    tools_must=$(echo "$line" | sed -E "s/.*Selected tools must use: \[(.*)\]/\1/" | tr -d "'")
    echo -e "${GREEN}Selected tools must use:${RESET} $tools_must"
  fi

  if echo "$line" | grep -q "Selected tools may help:"; then
    tools_may=$(echo "$line" | sed -E "s/.*Selected tools may help: \[(.*)\]/\1/" | tr -d "'")
    echo -e "${YELLOW}Selected tools may help:${RESET} $tools_may"
    echo
    block=""
  fi

  # CALL
  if echo "$line" | grep -E -q "Tool call:|MCP call:|Power call:|Agent to agent call:|Special signal call:"; then
    timestamp=$(echo "$line" | awk '{print $1, $2}' | cut -d',' -f1)
    echo -e "${RED}--- CALL DETECTED --- [$timestamp]${RESET}"
    echo "$line"
    in_call=1
  elif [ $in_call -eq 1 ]; then
    # 連續輸出 call 後續行
    echo "$line"
    # 簡單判斷，當下一行是空或下一行時間戳就結束
    if [[ "$line" == "" ]] || [[ "$line" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2} ]]; then
      echo -e "${RED}--- END CALL ---${RESET}\n"
      in_call=0
    fi
  fi

done
