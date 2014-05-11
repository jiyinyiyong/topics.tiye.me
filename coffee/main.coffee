
apiHost = 'http://local.tiye.me'

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
      $.ajax
        url: "#{apiHost}/auth"
        type: 'POST'
        data: data
        xhrFields:
          withCredentials: true
        success: (res) =>
          if res.status?
            @authName res.name
          else
            console.log res
            alert JSON.stringify res
        error: (event) ->
          console.log event
          alert "failed: #{event.response}"
    authName: (name) ->
      @name = name
      @logined = yes
      @wantLogin = no
    logout: ->
      $.ajax
        url: "#{apiHost}/logout"
        type: 'POST'
        xhrFields:
          withCredentials: true
      @logined = no

$.ajax
  url: "#{apiHost}/topics"
  type: 'GET'
  xhrFields:
    withCredentials: true
  success: (data) ->
    if data.name?
      app.authName data.name
    app.load data.list