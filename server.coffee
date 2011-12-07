connect = require 'connect'
browserify = require 'browserify'

server = connect()
server.use connect.static "#{__dirname}/public"
server.use browserify entry: "#{__dirname}/modules/entry.coffee"
server.listen 1984

console.log 'listening on 1984...'
  