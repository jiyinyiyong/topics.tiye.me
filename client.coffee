
ll = (v...) -> console.log vi for vi in v
set_interval = (duration, f) ->
  setInterval f, duration*1000
set_timeout = (duration, f) ->
  setTimeout f, duration*1000

tag = document.getElementById
create = (obj) ->
  elem = document.createElement obj.tag
  if obj.id?
    elem.setAttribute 'id', obj.id
  if obj.clas?
    elem.setAttribute 'class', obj.clas
  return elem

socket = io.connect window.location.hostname

timer = ''

set_interval 1, ->
  socket.emit 'watch_stemp'
  timer = set_timeout 3, ->
    do window.location.reload
socket.on 'watch_stemp', (watch_stemp, start_stemp) ->
  clearTimeout timer
  if watch_stemp isnt localStorage.watch_stemp
    localStorage.watch_stemp = watch_stemp
    set_timeout 1, ->
      do window.location.reload
  else if start_stemp isnt localStorage.start_stemp
    localStorage.start_stemp = start_stemp
    set_timeout 1, ->
      do window.location.reload

socket.on 'new_page', (list) ->
  ll list