
Dispatcher = require '../utils/dispatcher'
ajax = require '../utils/ajax'

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
  ajax.req 'GET', '/topics', (topics) =>
    if topics.length < 20 then local.loaded = yes
    model.merge topics

model.more = ->
  time = undefined
  for topic in local.topics
    if time?
      if topic.time < time then time = topic.time
    else
      time = topic.time
  if loaded.loaded then return
  ajax.req 'GET', "/topics/#{time}", (topics) =>
    if topics.length < 20 then local.loaded = yes
    model.merge topics

model.merge = (topics) ->
  topicsIds = local.topics.map (topic) => topic._id

  for topic in topics
    unless topic._id in topicsIds
      local.topics.push topic

  @emit 'change'

model.search = (query) ->
  local.query = query.trim()
  @emit()

  ajax.req 'GET', '/search', query: query, (topics) =>
    local.results = topics
    @emit()

model.isSearching = ->
  local.query.length > 0

model.isLoaded = ->
  local.loaded

model.load()

model.updateTopic = (data) ->
  for topic in local.topics
    if topic._id is data._id
      topic.note = data.note
      ajax.req 'PUT', "/topic/#{data._id}", data
      break

model.deleteTopic = (id) ->
  local.topics = local.topics.filter (topic) =>
    topic._id isnt id
  ajax.req 'DELETE', "/topic/#{id}"
  @emit()