args = (require 'minimist')(process.argv)
fs = require 'fs'
needle = require 'needle'
path = require 'path'

couchDb = args._.2
dirs = args._.slice 3

uploadDirectory (dir)! =
    jsonFiles = [file <- fs.readdir (dir)!, r/\.json$/.test (file), "#(dir)/#(file)"]
    uploadedFiles = [file <- jsonFiles, uploadFile (file)!]

uploadFile (file)! =
    json = JSON.parse (fs.readFile (file, 'utf-8')!)
    id = path.basename (file, '.json')
    console.log (id)
    url = "#(couchDb)/#(id)"
    response = needle.get (url, headers: {accept = "application/json"})!

    console.log ('status code', response.statusCode)
    if (response.statusCode == 200)
        console.log "updating json"
        console.log (response.body :: String)
        json._id = response.body._id
        json._rev = response.body._rev
    
    console.log (json)

    response = needle.put (url, json, json: true)!

    console.log (response.status)
    console.log (response.body)

[dir <- dirs, uploadDirectory (dir)!]
