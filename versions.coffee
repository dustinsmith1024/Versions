express = require('express')
io = require('socket.io')
Version = require('./models/versions').VersionModel
Version = new Version()

app = module.exports = express.createServer()

socket = io.listen(app)

socket.on('connection', (client) ->
  username = ''
  client.send('Welcome to this socket.io chat server!')
  client.send('Please input your username: ')
  client.on('message',(message) -> 
    if (!username)
      username = message
      client.send('Welcome, ' + username + '!')
    
    socket.broadcast(username + ' sent: ' + message);
  )  
)

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

app.get('/new', (req, res) ->
  console.log("new version request")
  Version.newVersion((err, status) ->
    throw err if err
    console.log(status)
    res.send(status)
  )
)

app.post('/versions/new', (req, res) ->
  console.log("POST: new version request")
  console.log(req.body)
  Version.newVersion(req.body, (err, status) ->
    if err
      throw err
    if status is "success"
      Version.findLatest( (err, version) ->
        console.log(version)
        res.send(version, { 'Content-Type': 'text/plain' })
      )
    )
  )

app.get('/versions', (req, res) ->
  console.log("versions request")
  Version.findAll((err, versions) ->
    if err
      throw err
    console.log(versions)
    res.send(versions,{ 'Content-Type': 'text/plain' })
  )
)

app.get("/versions/current/:amount?", (req, res) ->
  console.log("current versions request - params: " + req.params.amount)
  amount = if req.params.amount then req.params.amount else 5
  Version.findRecent((err, versions) ->
    if err
      throw err
    console.log(versions)
    res.send(versions,{ 'Content-Type': 'text/plain' })
  , amount)
)

app.listen(3000)

