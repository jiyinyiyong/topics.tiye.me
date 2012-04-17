
ll = (v...) -> console.log vi for vi in v
set_interval = (duration, f) ->
  setInterval f, duration*1000
set_timeout = (duration, f) ->
  return setTimeout f, duration*1000

window.tag = (id_str) ->
  document.getElementById id_str
create = (obj) ->
  elem = document.createElement obj.tag
  if obj.id?
    elem.setAttribute 'id', obj.id
  if obj.clas?
    elem.setAttribute 'class', obj.clas
  return elem

tag_list = tag 'list'
tag_nav  = tag 'nav'

socket = io.connect window.location.hostname

timer = {}
set_interval 1, ->
  socket.emit 'watch_stemp'
  timer = set_timeout 1, ->
    do window.location.reload
    clearTimeout timer
socket.on 'watch_stemp', (watch_stemp, start_stemp) ->
  clearTimeout timer
  if start_stemp isnt localStorage.start_stemp
    localStorage.start_stemp = start_stemp
    localStorage.watch_stemp = watch_stemp
  if watch_stemp isnt localStorage.watch_stemp
    localStorage.watch_stemp = watch_stemp
    do window.location.reload

authed = no
append_list = (item) ->
  time = item.time
  text = item.text
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
  lines = text.split('\n').map (x) ->
    x.replace(/^\s\s(.+)$/, '<pre><code>$1</code></pre>')
  lines = lines.map (x) ->
    x.replace(/`([^`]*[^\\`]+)`/g,
      '<code class="code">$1</code>')
      .replace(/(https?:(\/\/)?\S+)/g, '<a href="$1">$1</a>')
      .replace(/#(\w+)#/g, '<span class="bold">$1</span>')
  text = (lines.join '<br>')
    .replace(/<\/code><\/pre><br><pre><code>/g, '\n')
  item_div = create tag: 'div'
  item_span = create tag:'span', clas:'time'
  item_span.innerText = time
  item_div.appendChild item_span
  if authed
    id_str = item.time
    item_delete = create tag:'span', clas:'delete', id:id_str
    item_delete.innerText = 'x'
    item_div.appendChild item_delete
    item_delete.onclick = ->
      if confirm('Sure to delete?')
        socket.emit 'delete', item.time
        target = (tag id_str).parentNode
        target.parentNode.removeChild target
  item_text = create tag:'div', clas:'text'
  item_text.innerHTML = text
  item_div.appendChild item_text
  tag_list.appendChild item_div

clear_list = ->
  while tag_list.lastChild?
    tag_list.removeChild tag_list.lastChild

socket.on 'new_page', (list) ->
  # ll 'render new_page'
  do clear_list
  for item in list
    append_list item

(tag 'search').onmouseover = ->
  @select()
(tag 'search').onmouseout = ->
  @blur()
(tag 'search').onkeydown = (event) ->
  if @selectionStart is @selectionEnd
    if event.keyCode in [13]
      socket.emit 'search', @value.trim()
      return false
    else if event.keyCode is 8
      find_tail = @value.match /^(.*)\s\S+\s*?$/
      if find_tail?
        @value = find_tail[1]
        return false
      find_body = @value.match /^\S+\s*$/
      if find_body?
        @value = ''
        return false
      find_empty = @value.match /^\s+$/
      if find_empty?
        @value = ''
(tag 'get_all').onclick = ->
  socket.emit 'get_all'
(tag 'get_new').onclick = ->
  socket.emit 'get_new'
document.onkeydown = (event) ->
  if event.keyCode is 13
    (tag 'search').select()
    return false

socket.on 'all_page', (list) ->
  # ll 'render all_page'
  do clear_list
  for item in list
    append_list item

socket.on 'search', (list) ->
  do clear_list
  # ll 'rendering search', list
  for item in list
    append_list item

render_post = ->
  do clear_list
  tag_list.innerHTML = "<textarea id='post_text'
    ></textarea><br><button id='send_post'>Send</button>"
  (tag 'post_text').focus()
  (tag 'send_post').onclick = ->
    socket.emit 'post_text', (tag 'post_text').value

(tag 'post').onclick = ->
  if authed then do render_post
  else
    do clear_list
    tag_list.innerHTML = "<div id='hint'>password:</div>
    <input id='password' type='password'/>"
    (tag 'password').focus()
    (tag 'password').oninput = ->
      socket.emit 'password', @value

socket.on 'login_work', (password_stemp) ->
  localStorage.password_stemp  = password_stemp
  authed = yes
  do render_post

if localStorage.password_stemp?
  socket.emit 'password_stemp', localStorage.password_stemp
socket.on 'password_stemp', ->
  authed = yes