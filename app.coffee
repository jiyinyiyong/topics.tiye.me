
ll = console.log
set_timeout = (duration, f) ->
  return setTimeout f, duration*1000

fs = require 'fs'
url = require 'url'

coffee_path = '/home/chen/git/docview/libs/coffee-script.js'
coffee_file = fs.readFileSync coffee_path, 'utf-8'

date_stemp = -> String (new Date())
start_stemp = do date_stemp
watch_stemp = do date_stemp

page = ''
client = ''
load_file = ->
  page = fs.readFileSync 'page.html', 'utf-8'
  client = fs.readFileSync 'client.coffee', 'utf-8'

watch = require 'watch'
watch.watchTree __dirname, (f, curr, prev) ->
  do load_file
  watch_stemp = do date_stemp

app = (require 'http').createServer (req, res) ->
  pathname = (url.parse req.url).pathname
  if pathname in ['/', '/index.html']
    res.writeHead 200, 'Content-Type':'text/html'
    res.end page
  else if pathname is '/client.coffee'
    res.writeHead 200, 'Content-Type':'text/coffeescript'
    res.end client
  else if pathname is '/coffee-script.js'
    res.writeHead 200, 'Content-Type':'text/javascript'
    res.end coffee_file
.listen 8000
io = (require 'socket.io').listen app
io.set 'log level', 1

mongo = 'mongodb://node:nodepass@localhost:27017/daily_notes'
(require 'mongodb').connect mongo, (err, db) ->
  io.sockets.on 'connection', (socket) ->

    socket.on 'watch_stemp', ->
      socket.emit 'watch_stemp', watch_stemp, start_stemp

    do new_page = ->
      db.collection 'list', (err, coll) ->
        coll.find({}, {sort:{time:-1},limit: 20})
          .toArray (err, list) ->
            socket.emit 'new_page', list

    socket.on 'search', (keywords) ->
      keys = (keywords.split ' ').map (x) -> "(#{x})"
      try
        keys = keys.map (x) -> new RegExp x
      catch error
        keys = [/empty/]
      # ll keys
      db.collection 'list', (err, coll) ->
        coll.find({text: {$all: keys}}).toArray (err, list) ->
          # ll list
          socket.emit 'search', list

    socket.on 'get_new', ->
      do new_page

    socket.on 'get_all', ->
      do all_page = ->
        db.collection 'list', (err, coll) ->
          coll.find({}).toArray (err, list) ->
            socket.emit 'all_page', list

    authed = no
    login_work = {}
    socket.on 'password', (password) ->
      if password is 'pass'
        login_work = set_timeout 2, ->
          authed = yes
          password_stemp = date_stemp()
          db.collection 'password', (err, coll) ->
            coll.drop()
            coll.save {password: password_stemp}
          socket.emit 'login_work', password_stemp
      else
        clearTimeout login_work

    socket.on 'password_stemp', (password_stemp) ->
      db.collection 'password', (err, coll) ->
        coll.find({}).toArray (err, list) ->
          if list?
            if list[0].password is password_stemp
              authed = yes
              socket.emit 'password_stemp'

    socket.on 'post_text', (post_text) ->
      if authed
        db.collection 'list', (err, coll) ->
          time = new Date()
          year = (String time.getFullYear())[2..]
          month = time.getMonth() + 1
          date = time.getDate()
          hour = time.getHours()
          minute = time.getMinutes()
          time_stemp = "#{year}/#{month}/#{date}
            #{hour}:#{minute}"
          coll.save time:time_stemp, text:post_text 
          do new_page

    socket.on 'delete', (item_id) ->
      if authed
        ll item_id
        db.collection 'list', (err, coll) ->
          coll.remove {time: item_id}