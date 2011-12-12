$ ->
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

  @centre = (element, offset) =>
    unless offset?
      element.css "left", "#{($(window).width() / 2) - (element.width() / 2)}px"
    else
      console.log element.id, offset / 100
      element.css "left", "#{($(window).width() * (offset / 100)) - (element.width() / 2)}px"

  @reset = () =>
    @word = words[keys[Math.floor(Math.random() * keys.length)]]
    @tries = 0

    attempts.fadeOut =>
      attempts.empty()
      attempts.show()

    kana_answer.fadeOut =>
      kana_answer.removeClass()
      kana_answer.text @word.kana
      @centre kana_answer, 25

    rj_answer.fadeOut =>
      rj_answer.removeClass()
      rj_answer.text @word.meaning
      @centre rj_answer, 75


    kana_entry.val ''
    rj_entry.val ''
    subject.fadeOut =>
      subject.removeClass()
      subject.text @word.kanji
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
    setTimeout (=> @reset()), 1000

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

    if @tries is 3
      subject.addClass 'wrong'
      kana_answer.addClass 'wrong'
      kana_answer.fadeIn()
      kana_entry.fadeOut()
      rj_entry.fadeOut()
      rj_answer.addClass 'wrong'
      rj_answer.fadeIn()
      setTimeout (=> @reset()), 1000

  @rj_correct = () =>
    rj_entry.fadeOut()
    rj_answer.addClass 'correct'
    rj_answer.fadeIn()

  words =
    1:
      kanji: "図書館", kana: "としょかん", meaning: "Library"
    2:
      kanji: "仕事", kana: "しごと", meaning: "Work"
    3:
      kanji: "行く", kana: "いく", meaning: 'To go'
    
  keys = Object.keys words

  subject.hide()
  kana_answer.hide()
  rj_answer.hide()
  @reset()

  kana_entry.change () =>
    if kana_entry.val() is @word.kana
      @kana_correct()
      @rj_correct()
    else
      @wrong_input kana_entry.val()
      
  rj_entry.change () =>      
    if rj_entry.val() is @word.meaning.toLowerCase()
      # @kana_correct()
      @rj_correct()
    else
      @wrong_input rj_entry.val()