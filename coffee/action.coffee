
userModel = require './models/user'

exports.sign = ->
  userModel.setSign yes

exports.cancel = ->
  userModel.setSign no

exports.login = (password) ->
  userModel.login password

exports.logout = ->
  userModel.logout()