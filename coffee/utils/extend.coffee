
window.$ = React.DOM
window.$$ = $$ = {}

$$.switch = (name, registry) ->
  registry[name]()

$$.if = (cond, a, b) ->
  if cond then a() else b?()

$$.concat = (args...) ->
  list = []
  for arg in args
    list.push arg if arg?
  list.join(' ')

$$.list = (args...) ->
  children = args[1..]
  for arg, index in children
    arg.key = index
  children