
ll = console.log

fs = require 'fs'
url = require 'url'
password: 'pass'

coffee_path = '/home/chen/code/home/git/docview/libs/coffee-script.js'
coffee_file = fs.readFileSync coffee_path, 'utf-8'

<<<<<<< HEAD
app = (require 'http').createServer (req, res) ->
  page = fs.readFileSync 'page.html', 'utf-8'
  client = fs.readFileSync 'client.coffee', 'utf-8'
=======
start_stemp = (new Date()).getTime()
watch_stemp = 0

page = ''
client = ''
load_file = ->
  page = fs.readFileSync 'page.html', 'utf-8'
  client = fs.readFileSync 'client.coffee', 'utf-8'

watch = require 'watch'
watch.watchTree __dirname, (f, curr, prev) ->
  do load_file
  watch_stemp += 1

app = (require 'http').createServer (req, res) ->
>>>>>>> origin/master
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

<<<<<<< HEAD
mongo = 'mongodb://node:nodepass@localhost:27017/daily_notes'
(require 'mongodb').connect mongo, (err, db) ->
  io.sockets.on 'connection', (socket) ->

    db.collection 'list', (err, coll) ->
      coll.find {}, (err, cursor) ->
        list = []
        cursor.each (item) ->
=======
mongo = 'mongodb://node:nodepass@localhost:27017/daily_bookmarks'
(require 'mongodb').connect mongo, (err, db) ->
  io.sockets.on 'connection', (socket) ->

    socket.emit 'start_stemp', start_stemp
    socket.on 'watch_stemp', ->
      socket.emit 'watch_stemp', watch_stemp

    do visitor_new_page = ->
      db.collection 'list', (err, coll) ->
        coll.find {}, (err, cursor) ->
          list = []
          cursor.each (item) ->
            if item? then list.push item
            else socket.emit 'visitor_new_page'
>>>>>>> origin/master
