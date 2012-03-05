module.exports = class Client
  constructor: (args = {}) ->
    @socket = args.socket
    @words = args.words

    @socket.on 'request_word', () =>
      index = (Math.random() * @words.length)
      console.log index
      @socket.emit 'new_word', @words[Math.floor index]