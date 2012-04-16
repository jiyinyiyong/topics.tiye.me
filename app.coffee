
ll = console.log

fs = require 'fs'
url = require 'url'
password: 'pass'

coffee_path = '/home/chen/code/home/git/docview/libs/coffee-script.js'
coffee_file = fs.readFileSync coffee_path, 'utf-8'

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
io = (require 'socket.io').listen app
io.set 'log level', 1

mongo = 'mongodb://node:nodepass@localhost:27017/daily_notes'
(require 'mongodb').connect mongo, (err, db) ->
  io.sockets.on 'connection', (socket) ->

    db.collection 'list', (err, coll) ->
      coll.find {}, (err, cursor) ->
        list = []
        cursor.each (item) ->