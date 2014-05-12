
ajax = require './ajax'
try
  password = localStorage.getItem 'password'
window.onbeforeunload = ->
  localStorage.setItem 'password', app.$data.password

Vue.filter 'short', (time) ->
  (new Date time).toDateString()

window.app = new Vue
  el: '#body'
  data:
    logined: no
    hasMore: yes
    wantLogin: no
    name: 'anonym'
    topics: []
    password: password or ''
    query: ''
  methods:
    load: (list) ->
      @topics = list
    wantAdmin: ->
      @wantLogin = yes
    auth: ->
      data =
        password: @password
      ajax.req 'POST', '/auth', data, (res) =>
        if res.status?
          @authName res.name
        else
          console.log res
          alert JSON.stringify res
    authName: (name) ->
      @name = name
      @logined = yes
      @wantLogin = no
    logout: ->
      ajax.req 'POST', '/logout'
      @logined = no
    update: (topic) ->
      id = topic._id
      data =
        note: topic.note
      ajax.req 'PUT', "/topic/#{id}", data
    remove: (id, index) ->
      @topics.splice index, 1
      ajax.req 'DELETE', "/topic/#{id}"
    loadMore: ->
      lastOne = @topics[@topics.length - 1]
      time = (new Date lastOne.time).valueOf()
      ajax.req 'GET', "/topics/#{time}", (list) =>
        if list.length > 0
          @topics.push list...
        if list.length < 20
          @hasMore = no
    search: ->
      @query = @query.trim()
      if @query.length > 1
        data =
          query: @query
        ajax.req 'GET', '/search', data, (list) =>
          @topics = list

ajax.handleError (data) ->
  console.log 'error', data

ajax.req 'GET', '/topics', (list) ->
  app.load list
  if list.length < 20
    app.$data.hasMore = no

ajax.req 'GET', '/name', (data) ->
  app.authName data.name

window.onfocus = ->
  ajax.req 'GET', '/topics', (list) ->
    for topic in list.reverse()
      unless topic in app.$data.topics
        app.$data.topics.unshift topic