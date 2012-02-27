$ ->
  socket = io.connect null, reconnect: on, 'reconnection delay': 500, 'max reconnection attempts': 100

  socket.on 'connect', () ->
    console.log 'you are connected'
    socket.emit 'request_word'

  socket.on 'new_word', (word) =>
    console.dir word
    @word = word
    @reset()

  list = $ '#words'

  subject = $ '#subject'
  attempts = $ '#attempts'
  kana_entry = $ '#kana_entry'
  rj_entry = $ '#rj_entry'
  rj_answer = $ '#rj_answer'
  kana_answer = $ '#kana_answer'
  rj_overlay = $ '#rj_overlay'
  kana_overlay = $ '#kana_overlay'

  # test = $ "<span id='test'>|</span>"

  body = $ "body"

  @tries = 0

  @wrong_time = 5000
  @correct_time = 2000
  @hint_time = 10000

  @centre = (element, offset) =>
    unless offset?
      element.css "left", "#{($(window).width() / 2) - (element.width() / 2)}px"
    else
      element.css "left", "#{($(window).width() * (offset / 100)) - (element.width() / 2)}px"

  @reset = () =>
    @tries = 0
    clearTimeout @hint
    @hint = setTimeout (=> @rj_correct()), @hint_time

    attempts.fadeOut =>
      attempts.empty()
      attempts.show()

    kana_answer.fadeOut =>
      kana_answer.removeClass()
      kana_answer.text @word.kana
      @centre kana_answer, 25

    rj_answer.fadeOut =>
      rj_answer.removeClass()
      rj_answer.text @word.rj
      @centre rj_answer, 75


    kana_entry.val ''
    rj_entry.val ''
    subject.fadeOut =>
      subject.removeClass()
      subject.text @word.kotoba
      subject.fadeIn()
      kana_entry.fadeIn()
      rj_entry.fadeIn()
      @centre subject

    @centre kana_entry, 25
    @centre rj_entry, 75
    @centre attempts

  @kana_correct = () =>
    subject.addClass 'correct'
    kana_answer.addClass 'correct'
    kana_answer.fadeIn()
    kana_entry.fadeOut()
    @rj_correct()
    setTimeout (=> socket.emit 'request_word'), @correct_time

  @rj_correct = () =>
    rj_entry.fadeOut()
    rj_answer.addClass 'correct'
    rj_answer.fadeIn()

  @wrong_input = (input) =>
    @tries++
    console.log @tries
    wrong = $ "<div class='wrong'>#{input}</div>"
    wrong.hide()
    attempts.append wrong
    wrong.fadeIn()
    @centre attempts

    if @tries is 2
      subject.addClass 'wrong'
      kana_answer.addClass 'wrong'
      kana_answer.fadeIn()
      kana_entry.fadeOut()
      rj_entry.fadeOut()
      rj_answer.addClass 'wrong'
      rj_answer.fadeIn()
      setTimeout (=> socket.emit 'request_word'), @wrong_time

  @rj_correct = () =>
    rj_entry.fadeOut()
    rj_answer.addClass 'correct'
    rj_answer.fadeIn()
  
  subject.hide()
  kana_answer.hide()
  rj_answer.hide()
  # @centre subject
  @centre kana_entry, 25
  @centre rj_entry, 75
  @centre attempts

  kana_entry.change () =>
    if kana_entry.val() is @word.kana
      @kana_correct()
      @rj_correct()
    else
      @wrong_input kana_entry.val()
      
  rj_entry.change () =>
    if rj_entry.val().length > 3
      if (@word.rj.toLowerCase().indexOf rj_entry.val()) > -1
        @rj_correct()
      else
        @wrong_input rj_entry.val()