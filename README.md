# Gemma4-12B-QAT-Uncensored-HauhauCS-Balanced — 公开资料镜像

> **这是 Hugging Face 仓库的公开资料镜像。**
>
> - 来源 HF 仓库：https://huggingface.co/HauhauCS/Gemma4-12B-QAT-Uncensored-HauhauCS-Balanced
> - 榜单来源：AI探路者Tim X 帖 https://x.com/aiexplorertim/status/2118947309992260083
> - **权重文件不在本仓库**：GitHub 单文件上限 100MB，本仓库最小量化也要几 GB，放不下。请用本仓库的 `download.sh` 从 Hugging Face 拉取权重。
> - HF 元数据：license=gemma，gated=false，downloads 约 71 万，创建 2026-06-22，修改 2026-06-25；核实日期 2026-11-09；模型卡抓取日期 2026-11-10
> - 许可证：Gemma；门控状态：gated=false（可匿名下载，无须令牌）
> - **许可证重要提醒：**本模型按 **Gemma 许可证（Gemma Terms of Use）**分发，不是 Apache 许可证。基底模型 google/gemma-4-12B-it 在 Hugging Face 上是**门控（gated）仓库**，使用前须先接受 Gemma 条款；本仓库本身 gated=false，可匿名下载。
> - 首选量化：Q4_K_M，7.38GB（本仓库唯一量化）
> - 备用量化：无其他量化（本仓库唯一量化即 Q4_K_M）
> - mmproj BF16 175MB（`./download.sh --mmproj` 下载）；另有 mtp-gemma-4-12B-it.gguf 253MB（MTP 草稿模型文件，`./download.sh mtp-gemma-4-12B-it` 下载）。
>
> 本仓库只含模型卡、下载脚本与许可证文件，不含任何权重文件。

## GGUF 量化表（来自 HF 文件树，2026-11-09 核实）

| 量化 | 文件 | 大小 | SHA-256 (LFS oid) |
|---|---|---|---|
| Gemma4-12B-QAT-Uncensored-HauhauCS-Balanced-Q4_K_M | `Gemma4-12B-QAT-Uncensored-HauhauCS-Balanced-Q4_K_M.gguf` | 7.38 GB (7381381760 字节) | `59656d7494d6376ca97e9e20b64ea2e16cd97f12ec6d47bfccba91cb785b5134` |
| mmproj-Gemma4-12B-QAT-Uncensored-HauhauCS-Balanced-BF16.gguf | `mmproj-Gemma4-12B-QAT-Uncensored-HauhauCS-Balanced-BF16.gguf` | 0.18 GB (175115264 字节) | `b59e815479b7e5f0665bd29e6784c104a368092bcbc63120148c606f9276ab8e` |
| mtp-gemma-4-12B-it.gguf | `mtp-gemma-4-12B-it.gguf` | 0.25 GB (253707328 字节) | `c50c91c35f04903815b2e8930cbb8c8c5bee0e1aa00748c30a7b8ff05d2310b4` |

## 下载权重

```bash
./download.sh            # 默认下载首选量化 Q4_K_M
./download.sh <量化名>    # 本仓库唯一量化为 Q4_K_M，无其他量化可选
./download.sh --list     # 列出全部可用量化与大小
./download.sh --mmproj   # 另下载 mmproj 文件
```

下载完成后逐个核对字节数与 SHA-256（LFS oid），对不上报错退出、不留坏文件。

---

## 原模型卡（来自 Hugging Face，逐字照录，已去掉 YAML frontmatter）

# Gemma4-12B-QAT-Uncensored-HauhauCS-Balanced

> **[Join the Discord](https://discord.gg/SZ5vacTXYf)** for updates, roadmaps, projects, or just to chat.

Gemma4-12B (QAT) uncensored by HauhauCS. **0/465 Refusals***

## About

No changes to datasets or capabilities — fully functional, 100% of what the original authors intended, just without the refusals. Built from the official QAT weights, so the 4-bit quant stays close to full-precision quality.

## Balanced

The **Balanced** variant (recommended — 99%+ of users will be happy here) uses optimized full uncensoring tuned especially for agentic coding, reasoning, creative writing and reliability-critical tasks. It reasons before answering and stays dependable and on-instruction. An **Aggressive** variant, for cases where Balanced still deflects too much, after current testing is not required.

## ~60% faster with MTP

Ships with an MTP (multi-token-prediction) draft head for **speculative decoding** — roughly **60% faster generation with identical output** (the model verifies every drafted token, so quality is unchanged — pure speed). This release is tuned to pair well with the included MTP head.

llama.cpp:
```bash
llama-server \
  -m Gemma4-12B-QAT-Uncensored-HauhauCS-Balanced-Q4_K_M.gguf \
  -md mtp-gemma-4-12B-it.gguf --spec-type draft-mtp \
  -ngl 99 -fa on
```

**Note:** the MTP speedup was currently tested by me through **llama.cpp** (`llama-server` / `llama-cli`).

## Downloads

| File | Type | Size |
|------|------|------|
| `Gemma4-12B-QAT-Uncensored-HauhauCS-Balanced-Q4_K_M.gguf` | Q4_K_M (text) | 6.9 GB |
| `mmproj-Gemma4-12B-QAT-Uncensored-HauhauCS-Balanced-BF16.gguf` | mmproj (vision) | 168 MB |
| `mtp-gemma-4-12B-it.gguf` | MTP speculative drafter | 242 MB |

> **Why only Q4_K_M?** Gemma 4 is quantization-aware-trained for ~4-bit, so Q4_K_M is the sweet spot — higher-precision quants add size with no real quality gain. Carefully quantized for best quality at 4-bit.

## Vision

Load the mmproj alongside the model for image input:
```bash
llama-server -m Gemma4-12B-QAT-Uncensored-HauhauCS-Balanced-Q4_K_M.gguf \
  --mmproj mmproj-Gemma4-12B-QAT-Uncensored-HauhauCS-Balanced-BF16.gguf -ngl 99 -fa on
```

## Recommended sampling

These are dialed in specifically for this HauhauCS build — use them for the intended behaviour and quality:

- `temperature 0.6`
- `top_k 64`
- `top_p 0.9`
- `min_p 0.05`
- `repeat_penalty 1.1`

This release is tuned end-to-end as its own thing; the settings above are part of that and aren't the stock Gemma defaults.

## Specs

- 12B dense · 256K (262144) context
- Vision (image input) via mmproj
- Based on [Gemma 4 12B](https://huggingface.co/google/gemma-4-12B-it) by Google DeepMind

## Compatibility

- Works with llama.cpp, LM Studio, Jan, koboldcpp, and other GGUF runtimes.
- **Multi-GPU + LM Studio:** I've personally noticed Gemma 4 can crash under LM Studio's *tensor-split* mode — use a single GPU (layer-split or priority order) for this model.

## Acknowledgements

- **Google DeepMind** — Gemma 4.
- The included `mtp-gemma-4-12B-it.gguf` speculative draft head comes from **Unsloth**'s Gemma 4 release — many thanks to the Unsloth team for it.


\* _Tested with both automated and manual refusal benchmarks — none have been found in standard use. A small number of edge-case prompts deflect on the first ask but comply on a re-ask or strategic framing. If you hit one that's actually obstructive to your use case, [join the Discord](https://discord.gg/SZ5vacTXYf) and flag it so I can work on it in a future revision._
