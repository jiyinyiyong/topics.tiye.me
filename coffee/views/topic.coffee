
mixins = require '../utils/mixins'

userModel = require '../models/user'

module.exports = React.createClass
  displayName: 'topics-item'
  mixins: [mixins.listenTo]

  getIntialState: ->
    logined: userModel.isLogined()

  componentDidMount: ->
    @listenTo userModel, @_onChange

  _onChange: ->
    @setState @getIntialState()

  render: ->

    $.div className: 'topic-item row-between',
      $.div className: 'column-align',
        $.div {},
          $.span className: 'topic-title',
            @props.data.title
          $.span className: 'topic-time',
            @props.data.time
        $.div
          contentEditable: yes
          className: 'topic-note'
          $props.data.note
      $.div
        className: 'topic-remove'
        if @state.logined then 'Delete'