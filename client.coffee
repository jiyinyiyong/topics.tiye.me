
ll = (v...) -> console.log vi for vi in v
<<<<<<< HEAD
=======
set_interval = (duration, f) ->
  setInterval f, duration*1000
set_timeout = (duration, f) ->
  setTimeout f, duration*1000
>>>>>>> origin/master

tag = document.getElementById
create = (obj) ->
  elem = document.createElement obj.tag
  if obj.id?
    elem.setAttribute 'id', obj.id
  if obj.clas?
    elem.setAttribute 'class', obj.clas
  return elem

socket = io.connect window.location.hostname
<<<<<<< HEAD
socket.emit 'once'

socket.on 'new_page', (list) ->
  ll list, '000'
=======

socket.on 'start_stemp', (start_stemp) ->
  local_start_stemp = localStorage.start_stemp
  start_stemp = String start_stemp
  localStorage.start_stemp = start_stemp
  if local_start_stemp?
    if local_start_stemp isnt start_stemp
      window.location.reload()

set_interval 1, ->
  socket.emit 'watch_stemp'
socket.on 'watch_stemp', (watch_stemp) ->
  if (String watch_stemp) isnt localStorage.watch_stemp
    localStorage.watch_stemp = String watch_stemp
    set_timeout 1, ->
      window.location.reload()
>>>>>>> origin/master
