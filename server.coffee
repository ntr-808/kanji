connect = require 'connect'
browserify = require 'browserify'
mongoose = require 'mongoose'
socket_io = require 'socket.io'
csv = require 'csv'

Client = require './modules/client.coffee'
Array::shuffle = -> @sort -> 0.5 - Math.random()


db = mongoose.connect 'mongodb://localhost/verbs'
words = []

mongoose.connection.on 'open', () =>
  console.log 'connected to db'
  csvp = csv()
  csvp.fromPath(__dirname+'/verb_list')
  csvp.on 'data', (data, index) =>
    word = {kotoba: data[0], kana: data[1], rj: data[2]}
    words.push word
    
    verb_model.findOne {kotoba: word.kotoba}, (err, doc) =>
      if error?
        console.dir error
      unless doc?
        verb = new verb_model word
        verb.save()

verb_schema = new mongoose.Schema
  kotoba: String
  kana: String
  rj: String

verb_model = mongoose.model 'verb', verb_schema

verb_col = new mongoose.Collection 'verbs', db

server = connect()
server.use connect.static "#{__dirname}/public"
server.use browserify entry: "#{__dirname}/modules/entry.coffee"
server.listen 1984

console.log 'listening on 1984...'

    
@io = socket_io.listen server

@io.sockets.on 'connection', (socket) =>
  client = new Client socket: socket, words: words
