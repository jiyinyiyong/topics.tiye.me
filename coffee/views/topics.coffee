
mixins = require '../utils/mixins'
TopicItem = require './topic'
topicsModel = require '../models/topics'
action = require '../action'

module.exports = React.createClass
  displayName: 'topics-view'
  mixins: [mixins.listenTo]

  getInitialState: ->
    topics: topicsModel.getTopics()
    results: topicsModel.getResults()
    searching: topicsModel.isSearching()
    loaded: topicsModel.isLoaded()

  _onChange: ->
    @setState @getInitialState()

  componentDidMount: ->
    @listenTo topicsModel, @_onChange

  render: ->
    if @state.searching
      topicsToRender = @state.results
    else
      topicsToRender = @state.topics

    topicsContent = topicsToRender.map (topic) =>
      TopicItem key: topic._id, data: topic

    $.div
      id: 'topic-list'
      className: 'app-page'
      $.input
        id: 'topic-search'
        ref: 'query'
        onKeyDown: (event) =>
          if event.keyCode is 13
            text = event.target.value
            action.query text
      topicsContent
      unless @state.loaded
        unless @state.searching
          $.div
            className: 'topic-more'
            onClick: =>
              action.more()
            'More'