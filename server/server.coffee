express = require 'express'
browserify = require 'browserify'
mongoose = require 'mongoose'
socket_io = require 'socket.io'
csv = require 'csv'

Client = require './modules/client.coffee'
Array::shuffle = -> @sort -> 0.5 - Math.random()

#-------------------SERVER------------------------

port = 1984

server = express.createServer()
server.use express.static "../public"
server.use browserify mount: '/browserify.js', entry: "../client/entry.coffee"

server.listen port, ->
  console.log 'listening on', port

io = socket_io.listen server

io.sockets.on 'connection', (socket) =>
  # console.log 'hi'
  client = new Client socket: socket, words: words

#---------------------DB--------------------------

db = mongoose.connect 'mongodb://localhost/verbs'
words = []

mongoose.connection.on 'open', () =>
  console.log 'connected to db'
  csv_parser = csv()
  csv_parser.fromPath('resources/verb_list')
  csv_parser.on 'data', (data, index) =>
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

# kanji_schema = new mongoose.Schema
#   kanji: String
#   onyomi: Array
#   kunyomi: Array