
ll = (v...) -> console.log vi for vi in v

tag = document.getElementById
create = (obj) ->
  elem = document.createElement obj.tag
  if obj.id?
    elem.setAttribute 'id', obj.id
  if obj.clas?
    elem.setAttribute 'class', obj.clas
  return elem

socket = io.connect window.location.hostname

socket.on 'start_stemp', (start_stemp) ->
  local_start_stemp = localStorage.start_stemp
  start_stemp = String start_stemp
  localStorage.start_stemp = start_stemp
  if local_start_stemp?
    if local_start_stemp isnt start_stemp
      do window.location.reload
socket.on 'saved_event', ->
  do window.location.reload