# curl-search-helpers

Tiny zero-dependency shell helpers for searching public APIs from the
command line. No API keys, no libraries — just curl + python3 for URL
encoding.

```
./hn.sh "AI agents" 7 10        # Hacker News (Algolia API), recent-first
./ax.sh "transformer" 8         # arXiv API, newest first
./gnews.sh "openai" 7 10        # Google News RSS
./bingrss.sh "llm" 5            # Bing News RSS
./ddg.sh "scaling laws" w 10    # DuckDuckGo HTML search
```

## Scripts

| Script | Source | Notes |
|---|---|---|
| `hn.sh` | HN Algolia API | story search, `--days` filter, recent-first |
| `ax.sh` | arXiv API | sorted by submittedDate desc |
| `gnews.sh` | Google News RSS | `when:` recency filter |
| `bingrss.sh` | Bing News RSS | simple query + max results |
| `ddg.sh` | DuckDuckGo HTML | `d/w/m` time filter, parsed results |

## Usage pattern

Each script takes a query as `$1` and prints plain lines (title + URL),
ready to pipe into `grep`, `head`, or a research pipeline.

## Requirements

- `curl`
- `python3` (only for URL quoting — no third-party packages)
