$ ->
  $('#toggle-button a').click ->
    bar = $('#sidebar')
    if bar.hasClass 'open'
      bar.toggleClass 'open'
      bar.toggleClass 'closed'
      bar.animate
        width: '50px'
      $('#content').animate
        'margin-left': '50px'
    else
      bar.animate
        width: '200px'
        ->
            bar.toggleClass('open');
            bar.toggleClass('closed');
      $('#content').animate
        'margin-left': '200px'