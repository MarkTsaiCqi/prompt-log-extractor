#!/bin/bash

declare -A freq
total=0

while IFS= read -r line; do
  if echo "$line" | grep -q "Selected prompts in order:"; then
    # 擷取 prompt 清單
    raw=$(echo "$line" | grep -oP "Selected prompts in order:\s*\[\K[^\]]+")
    IFS=',' read -ra prompts <<< "$(echo "$raw" | tr -d "'")"

    # 累計每個 prompt（排除 targets）
    for prompt in "${prompts[@]}"; do
      p=$(echo "$prompt" | xargs)
      if [[ -n "$p" && "$p" != "targets" ]]; then
        ((freq[$p]++))
      fi
    done
    ((total++))
  fi
done

# 輸出統計
echo "Total Entries: $total"
for key in "${!freq[@]}"; do
  echo "$key ${freq[$key]}"
done | sort
