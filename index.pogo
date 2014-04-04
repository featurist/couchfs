argv = (require 'minimist')(process.argv.slice 2, { boolean = ['get', 'put']})
fs = require 'fs'
needle = require 'needle'
path = require 'path'

needleOptions = {
    headers = {accept = "application/json"}
    secureProtocol =
        if (argv."3")
            'SSLv3_method'

    json = true
}

couchDb = argv._.0
args = argv._.slice 1

uploadDirectory (dir)! =
    jsonFiles = jsonFilesInDirectory (dir)!
    uploadedFiles = [file <- jsonFiles, uploadFile (file)!]

uploadFile (file)! =
    json = JSON.parse (fs.readFile (file, 'utf-8')!)
    id = path.basename (file, '.json')
    url = "#(couchDb)/#(id)"
    response = needle.get (url, needleOptions)!

    if (response.statusCode == 200)
        json._id = response.body._id
        json._rev = response.body._rev
    
    response = needle.put (url, json, needleOptions)!

    response.body

jsonFilesInDirectory (dir)! =
    [file <- fs.readdir (dir)!, r/\.json$/.test (file), "#(dir)/#(file)"]

downloadFile (file)! =
    id = path.basename (file, '.json')
    url = "#(couchDb)/#(id)"
    response = needle.get (url, needleOptions)!

    if (response.statusCode == 200)
        json = response.body
        fs.writeFile (file, JSON.stringify (json, null, 4))!
        console.log "#(url) => #(file)"

    "GET #(url) => #(response.statusCode)"

uploadDirectories (dirs)! =
    responses = [dir <- dirs, jsonResponse <- uploadDirectory (dir)!, jsonResponse]

    for each @(response) in (responses)
        console.log (response)

downloadFiles (files)! =
    responses = [file <- files, downloadFile (file)!]

    for each @(response) in (responses)
        console.log (response)

if (argv.get)
    downloadFiles (args)!
else if (argv.put)
    uploadDirectories (args)!
else
    console.log "usage: couchfs --put|--get COUCH_DB_URL DIRECTORY ..."
