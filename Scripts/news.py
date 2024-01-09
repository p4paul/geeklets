import feedparser

rss = feedparser.parse('http://feeds.bbci.co.uk/news/rss.xml')
limit = 120

news = rss['entries']
for e in news[:7]:
        data = e['description']
        item = (data[:limit] + '...') if len(data) > limit else data
        print("● ", item)
