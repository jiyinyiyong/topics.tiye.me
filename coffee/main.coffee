
require './utils/extend'

TopicsView = require './views/topics'
UserView = require './views/user'

AppView = React.createClass
  displayName: 'app-view'
  render: ->
    $.div {},
      UserView {}
      TopicsView {}

React.renderComponent AppView({}), document.body