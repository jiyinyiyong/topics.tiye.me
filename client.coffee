
authed = no
view = 'new'

ll = (v...) ->
  console.log v
elem = (id) ->
  document.getElementById id
create = (tag) ->
  document.createElement tag
text_node = (text) ->
  document.createTextNode text

main_bar = elem 'main_bar'
side_bar = elem 'side_bar'
show_new = elem 'show_new'
show_post= elem 'show_post'
show_all = elem 'show_all'

liuxian = (text) ->
  html = []
  for line in text.split '\n'
    line = line
      .replace(/>/g,'&gt;')
      .replace(/</g,'&lt')
    if line.match /^\/#/ then line = "<b>#{line[2..]}</b>"
    if line.match /^\ \ /
      line = "<pre><code>#{line[2..]}</code></pre>"
      line = line.replace /\t/g, '&nbsp;&nbsp'
    else if line.match /^\t/
      line = "<pre><code>#{line[1..]}</code></pre>"
      line = line.replace /\t/g, '&nbsp;&nbsp'
    else
      line = line.replace /`([^`]*[^\\`]+)`/g, '<code>$1</code>'
      line = line.replace /(https?:(\/\/)?(\S+))/g, '<a href="$1">$3</a>'
    html.push line
  html.join '<br>'

bookmark_item = (item) ->
  time = create 'div'
  time.appendChild (text_node item.time)
  time.setAttribute 'class', 'bookmark_time'
  text = create 'div'
  text.innerHTML = liuxian item.post
  text.setAttribute 'class', 'bookmark_text'

  wrap = create 'div'
  wrap.setAttribute 'class', 'bookmark_wrap'
  wrap.appendChild time
  wrap.appendChild text
  
  wrap

socket = io.connect window.location.hostname

socket.on 'new_bookmarks', (bookmarks) ->
  view = 'new'
  main_bar.innerHTML = ''
  for item in bookmarks
    main_bar.appendChild (bookmark_item item)

create_post = ->
  main_bar.innerHTML = ''
  textarea = create 'textarea'
  button = create 'div'
  button.setAttribute 'id', 'post_button'
  button.innerHTML = 'Click to Post.'

  main_bar.appendChild textarea
  main_bar.appendChild button

  button.onclick = ->
    if authed
      socket.emit 'create_post', textarea.value

  view = 'post'

show_new.onclick = ->
  if view isnt 'new'
    view = 'new'
    main_bar.innerHTML = 'goto New page'
    socket.emit 'new_bookmarks'

show_post.onclick = ->
  if not authed
    main_bar.innerHTML = ''
    view = 'post'

    local = {}
    local.email = localStorage.email
    local.md5 = localStorage.md5
    if local.email? and local.md5?
      socket.emit 'check_local', local
    else
      main_bar.innerHTML = "<p id='login_link'>Login</p>"
      login_link = elem 'login_link'
      login_link.onclick = ->
        navigator.id.get (assertion) ->
          socket.emit 'assertion', assertion
  else
    do create_post if view isnt 'post'

socket.on 'sync_user_info', (user) ->
  localStorage.email = user.email
  localStorage.md5 = user.md5
  authed = yes
  do create_post

show_all.onclick = ->
    view = 'all'
    main_bar.innerHTML = 'goto All page'
    socket.emit 'all_bookmarks'
socket.on 'all_bookmarks', (bookmarks) ->
  view = 'all'
  main_bar.innerHTML = ''
  for item in bookmarks
    main_bar.appendChild (bookmark_item item)