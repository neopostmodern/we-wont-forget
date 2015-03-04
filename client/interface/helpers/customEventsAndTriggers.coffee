isAtBottom = false

window.setInterval(->
  if $(window).scrollTop() + $(window).height() > $(document).height() - 300
    if not isAtBottom
      isAtBottom = true
      $("body").trigger('arrivedAtBottom')
  else
    if isAtBottom
      isAtBottom = false # reset
, 100)