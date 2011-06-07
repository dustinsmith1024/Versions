mongoose = require('mongoose')
Schema = mongoose.Schema;

# Schema definitions
# Add a parent field so that parents have children all in same db
VersionSchema = new Schema({
  language: String,
  number: String
})

mongoose.connect('mongodb://localhost/versionsdb')
mongoose.model('Version',VersionSchema)
Version = mongoose.model('Version')

VersionModel = () ->

# Disconnects from DB -> Only do at program exit
disconnect = () ->
  mongoose.disconnect()

# Create a new version
VersionModel.prototype.newVersion = (params, callback) ->
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

# FInds the latest number of versions
VersionModel.prototype.findLatest = (callback) ->
  Version.find({}).sort("_id",-1).limit(1).run( (err, versions) ->
    throw err if err
    console.log(versions)
    callback(null, versions)
  )

# Find most recent X amount of versions
VersionModel.prototype.findRecent = (callback, amount = 5) ->
  Version.find({}).sort("_id",-1).limit(amount).run( (err, versions) ->
    throw err if err
    console.log(versions)
    callback(null, versions)
  )

# Find all versions
VersionModel.prototype.findAll = (callback) ->
  Version.find({}, (err, versions) ->
    throw err if err
    console.log(versions)
    callback(null, versions)
  )


exports VersionModel = VersionModel
