# couchfs

## PUT

Place `.json` files in a directory, any directory. Then run:

    couchfs --put http://couch_server:5984/database_name directory ...

`couchfs` will upload all the couch documents in that directory, overwriting any existing changes (so be careful!)

## GET

    couchfs --get http://couch_server:5984/database_name a/file.json ...

Will download the document at `http://couch_server:5984/database_name/file` and put it in the path `a/file.json`.

## Options

`-3` allows connection to SSLv3 servers.
