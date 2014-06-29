
Dispatcher = require '../utils/dispatcher'
ajax = require 'component-ajax'

module.exports = model = new Dispatcher

local =
  topics: []
  loaded: no
  query: ''
  results: []

model.getTopics = ->
  local.topics.sort (a, b) =>
    b.time - a.time

model.getResults = ->
  local.results.sort (a ,b) =>
    b.time - a.time

model.load = ->
  if local.loaded then return
  ajax.get '/topics', (topics) =>
    model.merge topics

model.more = (time) ->
  if loaded.loaded then return
  ajax.get "/topics/#{time}", (topics) =>
    if topics.length < 20 then local.loaded = yes
    model.merge topics

model.merge = (topics) ->
  topicsIds = local.topics.map (topic) => topic._id

  for topic in topics
    unless topic._id in topicsIds
      model.topics.push topic

  @emit 'change'

model.search = (query) ->
  local.query = query.trim()
  @emit()

  ajax.get '/search', query: query, (topics) =>
    local.results = topics
    @emit()

model.isSearching = ->
  local.query.length > 0

model.isLoaded = ->
  local.loaded