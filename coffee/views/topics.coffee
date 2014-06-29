
mixins = require '../utils/mixins'

topicsModel = require '../models/topics'

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
    if @state.isSearching
      topicsToRender = @state.results
    else
      topicsToRender = @state.topics

    topicsContent = topicsToRender.map (topic) =>
      TopicItem key: topic._id, data: topic

    $.div
      id: 'topic-list'
      topicsContent
      unless @state.searching
        unless @state.loaded
          $.div
            className: 'more'
            'More'