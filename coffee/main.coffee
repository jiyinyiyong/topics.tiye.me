
require './utils/extend'

TopicsView = require './views/topics'
UserView = require './views/user'
action = require './action'

AppView = React.createClass
  displayName: 'app-view'
  render: ->
    $.div {},
      UserView {}
      TopicsView {}

React.renderComponent AppView({}), document.body

window.addEventListener 'focus', ->
  action.load()