#!/bin/bash

# 讀取標準輸入並計數 prompt 出現次數

declare -A freq
total=0

while IFS= read -r line; do
  ((total++))
  IFS=',' read -ra prompts <<< "$line"
  declare -A seen_this_line=()
  for prompt in "${prompts[@]}"; do
    p=$(echo "$prompt" | xargs) # 去除空白
    if [[ -n "$p" && -z "${seen_this_line[$p]}" ]]; then
      ((freq[$p]++))
      seen_this_line[$p]=1
    fi
  done
done

echo "Total Lines: $total"
for key in "${!freq[@]}"; do
  echo "$key ${freq[$key]}"
done | sort

