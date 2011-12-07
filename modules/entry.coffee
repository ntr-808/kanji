$ ->
  list = $ '#words'

  words =
    1:
      kanji: "図書館", kana: "としょかん", meaning: "library"
    2:
      kanji: "仕事", kana: "しごと", meaning: "work"
    
  for key, data of words
    do (key, data) =>
      word = $ "<div id=#{data.meaning}>言葉: #{data.kanji}</div>"
      list.append word
      kana_answer = $ """<input id="#{key}_answer_kana" placeholder="かな"/>"""
      rj_answer = $ """<input id="#{key}_answer_rj" placeholder="Romaji"/>"""

      kana_correct = () =>
        kana_answer.replaceWith $ """<div class="correct">#{data.kana}</div>"""
      meaning_correct = () =>
        rj_answer.replaceWith $ """<div class="correct">#{data.meaning}</div>"""

      kana_answer.change () =>
        if kana_answer.val() is data.kana
          kana_correct()
          meaning_correct()
          
      rj_answer.change () =>      
        if rj_answer.val() is data.meaning
          kana_correct()
          meaning_correct()
          

      list.append kana_answer
      list.append rj_answer