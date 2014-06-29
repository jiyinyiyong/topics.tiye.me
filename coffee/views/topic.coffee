
mixins = require '../utils/mixins'

userModel = require '../models/user'
action = require '../action'

module.exports = React.createClass
  displayName: 'topics-item'
  mixins: [mixins.listenTo]

  getInitialState: ->
    logined: userModel.isLogined()

  componentDidMount: ->
    @listenTo userModel, @_onChange

  _onChange: ->
    @setState @getInitialState()

  render: ->

    $.div className: 'topic-item row-between',
      $.div className: 'column-align',
        $.div {},
          $.span className: 'topic-title',
            @props.data.title
          $.span className: 'topic-time',
            @props.data.time
        $.input
          contentEditable: yes
          className: 'topic-note'
          value: @props.data.note
          ref: 'note'
          onBlur: =>
            topic = @props.data
            topic.note = @refs.note.getDOMNode().value
            action.topic topic
      $.div
        className: 'topic-remove'
        onClick: =>
          topicId = @props.data._id
          action.delete topicId
        if @state.logined then 'Delete'