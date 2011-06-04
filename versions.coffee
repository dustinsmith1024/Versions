express = require('express')
mongoose = require('mongoose')
Schema = mongoose.Schema;

VersionSchema = new Schema({
  language: String,
  number: String
})

mongoose.connect('mongodb://localhost/versionsdb')
mongoose.model('Version',VersionSchema)

disconnect = () ->
  mongoose.disconnect()

Version = mongoose.model('Version')
app = module.exports = express.createServer()

# BASIC CONFIGURATION FOR EXPRESS
app.configure( () ->
    app.use(express.methodOverride())
    app.use(express.logger())
    app.use(express.bodyParser())
    app.use(app.router)
)

# DEV SETTINGS ONLY
app.configure('development', () ->
    console.log("Using Development Environment")
    app.use(express.static(__dirname + '/public'))
    app.use(express.errorHandler({ dumpExceptions: true, showStack: true }))
)

# PROD SETTINGS ONLY
app.configure('production', () ->
  console.log("Using Production Environment")
  oneYear = 31557600000
  app.use(express.static(__dirname + '/public', { maxAge: oneYear }))
  app.use(express.errorHandler())
)

newVersion = (params, callback) ->
  console.log(params)
  version = new Version()
  version.language = params.language
  version.number = params.number
  version.save( (err) ->
    throw err if err
    findLatest((err, version) ->
      throw err if err
      callback(null, "Added " + version[0].language + " " + version[0].number)
    )
  )

findLatest = (callback) ->
  Version.find({}).sort("_id",-1).limit(1).run( (err, versions) ->
    throw err if err
    console.log(versions)
    callback(null, versions)
  )

findRecent = (callback, amount = 5) ->
  Version.find({}).sort("_id",-1).limit(amount).run( (err, versions) ->
    throw err if err
    console.log(versions)
    callback(null, versions)
  )

findAll = (callback) ->
  Version.find({}, (err, versions) ->
    throw err if err
    console.log(versions)
    callback(null, versions)
  )

app.get('/new', (req, res) ->
  console.log("new version request")
  newVersion((err, status) ->
    throw err if err
    console.log(status)
    res.send(status)
  )
)

app.post('/versions/new', (req, res) ->
  console.log("POST: new version request")
  console.log(req.body)
  newVersion(req.body, (err, status) ->
    if err
      throw err
    console.log(status)
    res.send(status, { 'Content-Type': 'text/plain' })
  )
)

app.get('/versions', (req, res) ->
  console.log("versions request")
  findAll((err, versions) ->
    if err
      throw err
    console.log(versions)
    res.send(versions,{ 'Content-Type': 'text/plain' })
  )
)

app.get("/versions/current/:amount?", (req, res) ->
  console.log("current versions request - params: " + req.params.amount)
  amount = if req.params.amount then req.params.amount else 5
  findRecent((err, versions) ->
    if err
      throw err
    console.log(versions)
    res.send(versions,{ 'Content-Type': 'text/plain' })
  , amount)
)

app.listen(3000)

