modules.exports = class Client
  constructor: (args = {}) ->
    @socket = args.socket
    @words = args.words

    @socket.on 'request_word', () =>
      @socket.emit 'new_word', words.pop()
