
ajax = require './ajax'

window.app = new Vue
  el: '#body'
  data:
    logined: no
    wantLogin: no
    name: 'anonym'
    topics: []
    password: ''
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

ajax.handleError (data) ->
  console.log 'error', data

ajax.req 'GET', '/topics', (list) ->
  app.load list

ajax.req 'GET', '/name', (data) ->
  app.authName data.name