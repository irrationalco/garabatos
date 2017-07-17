window.sidebarOpen = true
window.sidebarOpenWidth = '200px'
window.sidebarClosedWidth = '50px'
$(document).on 'click', '#toggle-button a', ->
  bar = $('#sidebar')
  if bar.hasClass 'open'
    bar.removeClass 'open'
    bar.addClass 'closed'
    bar.animate
      width: window.sidebarClosedWidth
    $('#content').animate
      'margin-left': window.sidebarClosedWidth
  else
    bar.animate
      width: window.sidebarOpenWidth
      ->
          bar.addClass 'open'
          bar.removeClass 'closed'
    $('#content').animate
      'margin-left': window.sidebarOpenWidth
  window.sidebarOpen = !window.sidebarOpen

$(document).on 'turbolinks:before-render', (event) ->
  bar = $(event.originalEvent.data.newBody).find('#sidebar')
  unless window.sidebarOpen
    bar.removeClass 'open'
    bar.addClass 'closed'
  size = if window.sidebarOpen then window.sidebarOpenWidth else window.sidebarClosedWidth
  bar.width size
  $(event.originalEvent.data.newBody).find('#content').css 'margin-left': size