
ll = console.log
fs = require 'fs'
url = require 'url'
password: 'pass'

coffee_path = '/home/chen/code/home/git/docview/libs/coffee-script.js'
coffee_file = fs.readFileSync coffee_path, 'utf-8'

events = require 'events'
reload_event = new events.EventEmitter()
reload_event.on 'saved_event', ->
  page = fs.readFileSync 'page.html', 'utf-8'
  client = fs.readFileSync 'client.coffee', 'utf-8'

watch = require 'watch'
watch.watchTree __dirname, (f, curr, prev) ->
  reload_event.emit 'saved_event'

start_stemp = (new Date()).getTime()

app = (require 'http').createServer (req, res) ->
  page = fs.readFileSync 'page.html', 'utf-8'
  client = fs.readFileSync 'client.coffee', 'utf-8'
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

mongo = 'mongodb://node:nodepass@localhost:27017/daily_bookmarks'
(require 'mongodb').connect mongo, (err, db) ->
  io = (require 'socket.io').listen app
  io.set 'log level', 1
  io.sockets.on 'connection', (socket) ->

    socket.emit 'start_stemp', start_stemp
    reload_event.on 'saved_event', ->
      process.nextTick ->
       socket.emit 'saved_event'

    do visitor_new_page = ->
      db.collection 'list', (err, coll) ->
        coll.find {}, (err, cursor) ->
          list = []
          cursor.each (item) ->
            if item? then list.push item
            else socket.emit 'visitor_new_page'