_s = require 'underscore.string'

$ ->
  # Dates
  @ms_per_day = 86400000
  @departure = new Date (Date.UTC 2011, 08, 20, 0, 0, 0)
  @now = Date.now()
  @arrival = new Date (Date.UTC 2011, 10, 21, 9, 20, 0)
  @pct = ((@now - @departure) / (@arrival - @departure))

  # Jquery
  pct = $ '#pct'
  days_left = $ '#days_left'
  days_down = $ '#days_down'
  gojira = $ '#gojira'
  g_label = $ '#g_label'

  # Updates
  update_values = () =>
    unless @now > @arrival
      days_down_val = _s.truncate ((@now - @departure) / @ms_per_day), 5, ' '
      days_left_val = _s.truncate ((@arrival - @now) / @ms_per_day), 5, ' '
      days_down.text "Days Down: #{days_down_val}"
      days_left.text "Days Left: #{days_left_val}"
    else
      days_down.text "Yeah for real."
      days_left.text "すごいですね？"

  update_pct = () => 
    @now = Date.now()
    unless @now > @arrival
      @pct = ((@now - @departure) / (@arrival - @departure))
      calculated = @pct * 100
      rounded = (Math.round calculated * 10e6) / 10e6
      pct.text "PCT: #{_s.pad rounded, 10, '0', 'right'}%"
      g_label.text "#{_s.pad rounded, 10, '0', 'right'}%"
    else
      pct.text "I'm here lol..."

  move_gman = () =>
    destination = ($(window).width() * @pct) - 250
    move("#gojira")
      .x(destination)
      .duration('2s')
      .end()
    move("#g_label")
      .x(destination + 180)
      .rotate(-20)
      .duration('2s')
      .end()
    
  # Init
  update_values()
  move_gman()

  r = Raphael 0, 0, $(window).width(), $(window).height()
  p = r.path "M50, 337H#{($(window).width() - 50)}"

  setInterval update_pct, 10
  setInterval update_values, 1000
  setInterval move_gman, 10000