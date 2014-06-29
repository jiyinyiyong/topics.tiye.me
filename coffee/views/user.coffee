
mixins = require '../utils/mixins'
userModel = require '../models/user'
action = require '../action'

module.exports = React.createClass
  displayName: 'user-view'
  mixins: [mixins.listenTo]

  getInitialState: ->
    name: userModel.getName()
    logined: userModel.isLogined()
    signing: userModel.isSigning()

  _onChange: ->
    @setState @getInitialState()

  componentDidMount: ->
    @listenTo userModel, @_onChange

  render: ->

    signingView = => $$.list {},
      $.input id: 'user-password', ref: 'password'
      $.button
        id: 'user-login'
        onClick: =>
          password = @refs.password.getDOMNode().value
          action.login password
        'Log in'
      $.button
        id: 'user-cancel'
        onClick: =>
          action.cancel()
        'Cancel'

    loginView = =>
      $.button
        id: 'user-admin'
        onClick: =>
          action.sign()
        'Log in'

    userView = => $$.list {},
      $.span id: 'user-name', @state.name
      $.button
        id: 'user-logout'
        onClick: =>
          action.logout()
        'log out'

    $.div id: 'user-view',
      $$.if @state.logined,
        userView
        => $$.if @state.signing,
          signingView
          loginView