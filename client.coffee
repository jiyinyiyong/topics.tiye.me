
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
socket.emit 'once'

socket.on 'new_page', (list) ->
  ll list, '000'