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
    url = "#(couchDb)/#(id)"
    response = needle.get (url, headers: {accept = "application/json"})!

    if (response.statusCode == 200)
        json._id = response.body._id
        json._rev = response.body._rev
    
    response = needle.put (url, json, json: true, headers: {accept = "application/json"})!

    response.body

responses = [dir <- dirs, jsonResponse <- uploadDirectory (dir)!, jsonResponse]

for each @(response) in (responses)
    console.log (response)
