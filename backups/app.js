express = require('express')
app = module.exports = express.createServer()

head = '<html><head><script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js" type="text/javascript"></script></head><body>'
foot = '</body></html>'

# BASIC CONFIGURATION FOR EXPRESS
app.configure( () ->
    app.use(express.methodOverride())
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

UserProvider = require('./userProvider').UserProvider
UserProvider = new UserProvider()

#Blog index
app.get('/all', (req, res) ->
  UserProvider.findAll( (error, users) ->
     console.log(users)
     res.send(users,{ 'Content-Type': 'text/plain' })
  )
)
VersionProvider = require('./userProvider').VersionProvider
VersionProvider = new VersionProvider()
VersionProvider.language = "Node.js"
VersionProvider.save

app.get('/versions', (req, res) ->
  VersionProvider.findAll( (error, versions) ->
     console.log(versions)
     res.send(versions,{ 'Content-Type': 'text/plain' })
  )
)

app.post('/users/new', (req, res) ->
  console.log("POST Request: " + key + " " + value) for own key, value of req.body
  #User = mongoose.model('User')
  #user = new UserProvider()
  UserProvider.name = req.body.name
  UserProvider.save( (err) ->
    if(!err)
      console.log('Success!')
  )
  res.send("Created user " + user.name)
)

addUser = (req, res) ->
  #User = mongoose.model('User')
  user = new User()
  user.name = req.body.name
  user.save( (err) ->
    if(!err)
      console.log('Success!')
  )

app.get('/users/all', (req, res) ->
    console.log("RES SENT")
    res.send(data)
)

app.get('/users/:id?', (req, res) ->
  if req.params.id is undefined
    res.send('Reroute to /users/all')
    console.log("RES SENT")
  else
    res.send('user ' + req.params.id)
)

app.post('/', addUser, (req, res) ->
  console.log("POST Request: " + key + " " + value) for own key, value of req.body
  res.send(req.body)
  console.log("After route")
)

app.listen(3000)
