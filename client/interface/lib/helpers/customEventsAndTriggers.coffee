isAtBottom = false

window.setInterval(->
  if $(window).scrollTop() + $(window).height() > $(document).height() - $(window).height() / 2
    if not isAtBottom
      isAtBottom = true
      $("body").trigger('arrivedAtBottom')
  else
    if isAtBottom
      isAtBottom = false # reset
, 100)

$(document).keypress(
  (event) ->
    if event.keyCode is 27 # escape
      $("body").trigger('escapeKey')
      share.EscapeManager.close()
)

escapeStatus =
  callback: null
  group: null

share.EscapeManager =
  register: (options) ->
    options ?= {}

    if escapeStatus.callback? and escapeStatus.group isnt options.group
      escapeStatus.callback()

    escapeStatus.callback = options.callback
    escapeStatus.group = options.group
  close: ->
    escapeStatus.callback()
    escapeStatus.callback = null
    escapeStatus.group = null