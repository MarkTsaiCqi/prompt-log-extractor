# prompt-log-extractor

一組用於解析 AI Agent 日誌中「Selected prompts in order」的輕量級 CLI 工具集合。

📄 適用場景：
- 從 `docker logs` 實時或歷史紀錄中萃取 prompt 清單
- 分析 AI 回應時引用的 prompts、分析、任務指示等細節
- 結合 grep / awk / bash，無需安裝額外依賴

## 🧩 工具一：`extract_prompts_batch.sh`

從包含 `Selected prompts in order:` 的 log 中，輸出每筆的時間與 prompt 清單（已排除 `targets`）。

### 使用方式：

```bash
cat log.txt | ./extract_prompts_batch.sh
```

## 🧩 工具二：`count_prompt_frequency.sh`

讀取多行 prompt 清單，統計每個 prompt 出現次數。

```bash
cat prompt_lines.txt | ./count_prompt_frequency.sh
```

## 🧩 工具三：`parse_prompt_blocks.sh`

解析 `Selected prompts in order:` 前後的日誌區塊，萃取出 analysis、targets、selected_prompts、prompts_order 與時間戳。

```bash
cat log_blocks.txt | ./parse_prompt_blocks.sh
```

## 📂 專案結構

```
prompt-log-extractor/
├── extract_prompts_batch.sh
├── count_prompt_frequency.sh
├── parse_prompt_blocks.sh
├── examples/
│   ├── raw_log_sample.txt
│   └── prompt_block_sample.txt
├── README.md
```

## 🪪 License

MIT
