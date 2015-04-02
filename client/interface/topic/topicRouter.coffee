topicRouteController = RouteController.extend(
  loadingTemplate: 'loading'
  waitOn: -> [
    Meteor.subscribe Tags.SUBSCRIPTIONS.ALL, {}
    Meteor.subscribe Topics.SUBSCRIPTIONS.ALL, {}
  ]
  template: 'topic'
  data: ->
    topic: Topics.findOne @params._id
  onAfterAction: ->
    Tracker.autorun =>
      pageId = @data().topic?.wikipediaPageId
      if pageId?
        Meteor.call(share.METHODS.WIKIPEDIA_SUMMARY, pageId, (error, result) =>
          if error?
            console.dir error
          else
            @state.set "wikipedia", result
        )
      return
)

topicRouteController.helpers(
  wikipediaSummary: ->
    @state.get "wikipedia"
  wikipediaIsSearching: ->
    @state.get "wikipediaIsSearching"
  wikipediaResults: ->
    @state.get "wikipediaResults"
)

topicRouteController.events(
  'submit form#search-wikipedia': (event, template) ->
    event.preventDefault()

    @state.set "wikipediaIsSearching", true
    Meteor.apply share.METHODS.WIKIPEDIA_SEARCH, [ template.find('.wikipedia-query').value ], (error, result) =>
      if error?
        alert error.message
      else
        @state.set 'wikipediaResults', result

      @state.set "wikipediaIsSearching", false

  'click #wikipedia-results button': (event, template) ->
    Meteor.apply(
      share.METHODS.ADD_WIKIPEDIA_PAGE_BY_TITLE
      [
        event.currentTarget.dataset.title
        Router.current().params._id
      ]
      (error, result) ->
        if error?
          alert error.message
    )
)

@TopicRouteController = topicRouteController

Router.route(share.ROUTE.TOPIC,
  path: share.PATH.TOPIC
  controller: 'TopicRouteController'
)