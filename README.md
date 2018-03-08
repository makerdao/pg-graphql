## pg-graphql

Cache Maker system data from the blockchain to PostgreSQL and serve
over GraphQL:

`npm run sync` - sync back from the latest block

`BLOCK=1234 npm run sync` - overwrite the cache from the specified block

`npm run subscribe` - sync any missing blocks & watch for future updates

`npm run graphql` - run graphql in development

`rpm build && npm serve` - run graphql in production
