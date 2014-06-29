
Dispatcher = require '../utils/dispatcher'
ajax = require '../utils/ajax'

module.exports = model = new Dispatcher

local =
  logined: no
  name: '?'
  signing: no

ajax.req 'GET', '/name', (data) ->
  local.name = data.name
  local.logined = yes
  model.emit()

model.login = (password) ->
  ajax.req 'POST', '/auth', {password}, (data) =>
    if data.error?
      alert data.error
    else
      local.name = data.name
      local.logined = yes
      local.signing = no
      @emit()

model.logout = ->
  local.logined = no
  ajax.req 'POST', '/logout'
  @emit()

model.isLogined = ->
  local.logined

model.getName = ->
  local.name

model.isSigning = ->
  local.signing

model.setSign = (status) ->
  local.signing = status
  @emit()