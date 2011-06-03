mongoose = require('mongoose')
mongoose.connect('mongodb://localhost/app');

# SETUP THE USER SCHEMA - SHOULD MOVE THESE TO A FOLDER
setUserSchema = (mongoose) ->
  Schema = mongoose.Schema
  User = new Schema(
      name  :  type: String, default: 'Anon'
    , age   :  type: Number, min: 18, index: true
    , bio   :  type: String, match: /[a-z]/
    , date  :  type: Date, default: Date.now
  )
  mongoose.model('User', User)

# CALL THE USER SCHEMA SETUP
setUserSchema(mongoose)

User = mongoose.model('User')

UserProvider = () -> 

#Find all users
UserProvider.prototype.findAll = (callback) ->
  User.find({}, (err, users) ->
    callback( null, users )
  )

exports.UserProvider = UserProvider
