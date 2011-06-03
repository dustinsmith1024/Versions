express = require('express')
app = module.exports = express.createServer()

mongoose = require('mongoose')
db = mongoose.connect('mongodb://localhost/mydb')

allowPosts = (mongoose) ->
  Schema = mongoose.Schema;
  Posts = new Schema(
    name : String,
    subject: String,
    comment : String,
    password: String,
  )
  mongoose.model('Post', Posts);

allowPosts(mongoose)

createNewPost = () ->
    Post = mongoose.model('Post')
    post = new Post()
    post.subject='hshja'
    post.comment ='ahsjashjas'
    post.save((err) ->
        if(!err)
            console.log('Post saved.')        
    )

findPosts = (amount) ->
    Post = mongoose.model('Post')
    console.log(Post.count({}, (err,count) ->
      console.log('Count:' + count)
    ))
    Post.find({}).limit(amount).each( (err,post) ->
        if post!=null then console.log(post.subject)
    )

createNewPost()
findPosts(10)

head = '<html><head><script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js" type="text/javascript"></script></head><body>'
foot = '</body></html>'
app.configure( () ->
    app.use(express.methodOverride())
    app.use(express.bodyParser())
    app.use(app.router)
)

app.configure('development', () ->
    console.log("Using Development Environment")
    app.use(express.static(__dirname + '/public'))
    app.use(express.errorHandler({ dumpExceptions: true, showStack: true }))
)

app.configure('production', () ->
  console.log("Using Production Environment")
  oneYear = 31557600000
  app.use(express.static(__dirname + '/public', { maxAge: oneYear }))
  app.use(express.errorHandler())
)

app.get('/', (req, res) ->
  res.send(head + 'hello world' + foot)
)

app.get('/users/:id?', (req, res) ->
  if req.params.id is undefined
    res.send('all users ')
  else
    res.send('user ' + req.params.id)
)

app.post('/', (req, res) ->
  console.log("POST Request: " + key + " " + value) for own key, value of req.body
  user = new UserModel()
  user.name = req.body.name
  user.save( (err) ->
    if !err then console.log('Success!')
  )
  res.send(req.body)
)

app.listen(3000)
