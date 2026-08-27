#!/bin/bash
# hn.sh "<query>" [days] [hits] — HN Algolia story search, recent-first
Q="$1"; DAYS="${2:-7}"; HITS="${3:-10}"
SINCE=$(( $(date -u +%s) - DAYS*86400 ))
curl -s --max-time 20 "https://hn.algolia.com/api/v1/search?query=$(python3 -c "import urllib.parse,sys;print(urllib.parse.quote(sys.argv[1]))" "$Q")&tags=story&numericFilters=created_at_i%3E$SINCE&hitsPerPage=$HITS" \
 | jq -r '.hits[] | "\(.created_at[0:10]) | \(.points)p/\(.num_comments)c | \(.title) | \(.url // "(no url)")"'
