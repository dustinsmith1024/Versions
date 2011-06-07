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

# SETUP THE VERSION SCHEMA - SHOULD MOVE THESE TO A FOLDER
setVersionSchema = (mongoose) ->
  Schema = mongoose.Schema
  Version = new Schema(
      language  :  type: String, default: 'Anon'
    , number   :  type: String, index: true
    , date  :  type: Date, default: Date.now
  )
  mongoose.model('Version', Version)

# CALL THE USER SCHEMA SETUP
setUserSchema(mongoose)
setVersionSchema(mongoose)

User = mongoose.model('User')
Version = mongoose.model('Version')

UserProvider = () -> 

VersionProvider = () ->

#Find all users
UserProvider.prototype.findAll = (callback) ->
  User.find({}, (err, users) ->
    callback( null, users )
  )

VersionProvider.prototype.findAll = (callback) ->
  Version.find({}, (err, versions) ->
    callback(null, versions )
  )

exports.UserProvider = UserProvider
exports.VersionProvider = VersionProvider
