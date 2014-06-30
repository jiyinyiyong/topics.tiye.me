
userModel = require './models/user'
topicsModel = require './models/topics'

exports.sign = ->
  userModel.setSign yes

exports.cancel = ->
  userModel.setSign no

exports.login = (password) ->
  userModel.login password

exports.logout = ->
  userModel.logout()

exports.topic = (data) ->
  topicsModel.updateTopic data

exports.delete = (id) ->
  topicsModel.deleteTopic id

exports.more = ->
  topicsModel.more()

exports.load = ->
  topicsModel.load()

exports.query = (text) ->
  topicsModel.search text