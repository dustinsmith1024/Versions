async = (data, callback) ->
  timeout = Math.ceil(Math.random() * 3000)
  setTimeout(() ->
    callback(null, data)
  , timeout)

console.log('calling async')

async(1, (err, data) ->
  console.log('async returned ' + data)
)

