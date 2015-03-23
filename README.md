Dungeon Survival
================

Parse Dungeon Crawl Stone Soup logfiles, extract event data

## TODO ([Kimball](http://www.kimballgroup.com/about-kimball-group/)-ize)

- initial strategy of getting all data from logfiles is flawed
- instead, build dimensions from souce
- monsters can be found [here](https://gitorious.org/crawl/crawl/source/6a27b25230144e365fc34c2df531008eb760e700:crawl-ref/source/mon-data.h) for example
- this will allow much richer data for dimensions, and enable slowly changing dimensions (over version)
- facts will come from logfiles, as will player dimension

## Planed Dimensions
- Monsters
- Branches
- Species / Background
- Skills
- Spells
- Gods
- Mutations
- Special Items?
- Time / Turns?

Morgue data is available here: http://crawl.develz.org/morgues/