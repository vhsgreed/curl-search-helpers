#!/bin/bash
# ax.sh "<arxiv query>" [max_results] — arxiv API search sorted by submittedDate desc
Q="$1"; N="${2:-8}"
curl -s -L --max-time 25 "https://export.arxiv.org/api/query?search_query=$(python3 -c "import urllib.parse,sys;print(urllib.parse.quote(sys.argv[1]))" "$Q")&start=0&max_results=$N&sortBy=submittedDate&sortOrder=descending" \
 | python3 -c "
import sys,re
xml=sys.stdin.read()
entries=re.findall(r'<entry>(.*?)</entry>', xml, re.S)
for e in entries:
    def g(tag):
        m=re.search(r'<'+tag+r'[^>]*>(.*?)</'+tag+r'>', e, re.S)
        return re.sub(r'\s+',' ',m.group(1)).strip() if m else ''
    title=g('title').replace('&amp;','&').replace('&quot;','\"').replace('&#39;',\"'\")
    date=g('published')[0:10]
    aid=re.search(r'arxiv.org/abs/([^v<]+)', e)
    cat=re.search(r'primary_category term=\"([^\"]+)\"', e)
    summ=g('summary')
    print(f'{date} | {aid.group(1) if aid else \"?\"} | [{cat.group(1) if cat else \"?\"}] {title}')
    print(f'   {summ[:400]}')
    print()
"
