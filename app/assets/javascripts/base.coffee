window.sidebarOpen = true
window.sidebarOpenWidth = '200px'
window.sidebarClosedWidth = '50px'
window.resizingTable = 0
window.activeLinkIdx = 1
$(document).on 'click', '#toggle-button a', ->
  bar = $('#sidebar')
  if bar.hasClass 'open'
    bar.removeClass 'open'
    bar.addClass 'closed'
    bar.animate
      width: window.sidebarClosedWidth
    $('#content').animate
      'margin-left': window.sidebarClosedWidth
      ->
        resizeTable()
  else
    bar.animate
      width: window.sidebarOpenWidth
      ->
        bar.addClass 'open'
        bar.removeClass 'closed'
    $('#content').animate
      'margin-left': window.sidebarOpenWidth
      ->
        resizeTable()
  window.sidebarOpen = !window.sidebarOpen

$(document).on 'turbolinks:before-render', (event) ->
  bar = $(event.originalEvent.data.newBody).find('#sidebar')
  unless window.sidebarOpen
    bar.removeClass 'open'
    bar.addClass 'closed'
  size = if window.sidebarOpen then window.sidebarOpenWidth else window.sidebarClosedWidth
  bar.width size
  $(event.originalEvent.data.newBody).find('#content').css 'margin-left': size
  bar.find('li').removeClass('active')
  $(bar.find('li')[window.activeLinkIdx]).addClass('active')

$(window).resize ->
  resizeTable()

$(document).on 'turbolinks:before-cache', (event) ->
  if $('.table').length
    $('.table').DataTable().destroy()

resizeTable = ->
  clearTimeout window.resizingTable
  window.resizingTable = window.setTimeout ->
      table = $('.table')
      if table.length
        table.width table.parent().width()
        table.dataTable().fnAdjustColumnSizing()
    500

$(document).on 'click', '#sidebar a', ->
  target = $(event.target).closest('li').first()
  unless target.attr('id') == 'toggle-button'
    target = target[0]
    for node, idx in $('#sidebar li')
      debugger
      if node == target
        window.activeLinkIdx = idx
        break