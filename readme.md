# couchfs

Place `.json` files in a directory, any directory. Then run:

    couchfs http://couch_server:5984/database_name directory ...

`couchfs` will upload all the couch documents in that directory, overwriting any existing changes (so be careful!)
