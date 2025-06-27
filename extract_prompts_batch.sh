#!/bin/bash

# 處理多行 log，提取 prompt 清單（排除 'targets'），並保留正確逗號與空白

while IFS= read -r line; do
  # 擷取中括號內文字
  raw=$(echo "$line" | grep -oP "Selected prompts in order:\s*\[\K[^\]]+")

  # 若有找到 prompt list 才處理
  if [[ -n "$raw" ]]; then
    # 去掉單引號，分割為陣列
    IFS=',' read -ra prompts <<< "$(echo "$raw" | tr -d "'")"

    # 過濾掉 'targets' 並整理輸出
    output=""
    for prompt in "${prompts[@]}"; do
      trimmed=$(echo "$prompt" | xargs) # 去空白
      if [[ "$trimmed" != "targets" ]]; then
        if [[ -n "$output" ]]; then
          output+=", $trimmed"
        else
          output="$trimmed"
        fi
      fi
    done
    echo "$output"
  fi
done

