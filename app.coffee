
ll = console.log
set_timeout = (duration, f) ->
  return setTimeout f, duration*1000

fs = require 'fs'
url = require 'url'

date_stemp = -> String (new Date())
watch_stemp = do date_stemp
start_start = do date_stemp

page = ''
client = ''
load_file = ->
  page = fs.readFileSync 'page.html', 'utf-8'
  client = fs.readFileSync 'client.coffee', 'utf-8'

watch = require 'watch'
watch.watchTree __dirname, (f, curr, prev) ->
  do load_file
  watch_stemp = do date_stemp

mongo = 'mongodb://node:nodepass@localhost:27017/daily_notes'
lab = 'mongodb://node:nodepass@ds031617.mongolab.com:31617/jiyinyiyong'
app = (require 'http').createServer (req, res) ->
  pathname = (url.parse req.url).pathname
  if pathname in ['/', '/index.html']
    res.writeHead 200, 'Content-Type':'text/html'
    res.end page
  else if pathname is '/client.coffee'
    res.writeHead 200, 'Content-Type':'text/coffeescript'
    res.end client
  else if pathname is '/all.json'
    res.writeHead 200, 'Content-Type': 'application/json'
    (require 'mongodb').connect lab, (err, db) ->
      db.collection 'list', (err, coll) ->
        coll.find({},{_id:0}).toArray (err, list) ->
          for item in list
            json = []
            for key, value of item
              json.push "\"#{key}\":\"#{value}\""
            res.write "{#{json.join ','}}\n"
          res.end ''
    
.listen 8000
io = (require 'socket.io').listen app
io.set 'log level', 1

(require 'mongodb').connect lab, (err, db) ->
  io.sockets.on 'connection', (socket) ->

    socket.on 'watch_stemp', ->
      socket.emit 'watch_stemp', watch_stemp, start_start

    do new_page = ->
      db.collection 'list', (err, coll) ->
        coll.find({}, {sort:{time:-1},limit: 20})
          .toArray (err, list) ->
            socket.emit 'new_page', list

    socket.on 'search', (keywords) ->
      keys = keywords.split(' ').filter (x) ->
        if x.length > 0 then true else false
      keys = keys.map (x) -> "(#{x})"
      try
        keys = keys.map (x) -> new RegExp x, 'i'
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
          try
            if list?
              if list[0].password is password_stemp
                authed = yes
                socket.emit 'password_stemp'
          catch error
            coll.save {password: 'empty'}

    socket.on 'post_text', (post_text) ->
      if authed
        db.collection 'list', (err, coll) ->
          time = new Date()
          year = (String time.getFullYear())[2..]
          month = String (time.getMonth() + 1)
          if month.length is 1 then month = '0'+month
          date = String time.getDate()
          if date.length is 1 then date = '0'+date
          hour = String time.getHours()
          if hour.length is 1 then hour = '0'+hour
          minute = String time.getMinutes()
          if minute.length is 1 then minute = '0'+minute
          second = String time.getSeconds()
          if second.length is 1 then second = '0'+second
          time_stemp = "#{year}/#{month}/#{date}
            #{hour}:#{minute}:#{second}"
          coll.save time:time_stemp, text:post_text 
          do new_page

    socket.on 'delete', (item_id) ->
      if authed
        db.collection 'list', (err, coll) ->
          coll.remove {time: item_id}