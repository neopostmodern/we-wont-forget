
Session.setDefault "topicGroupsCount", 3

homeRouter = RouteController.extend(
  template: 'home'
  waitOn: -> [
    Meteor.subscribe Tags.SUBSCRIPTIONS.ALL, {}
    Meteor.subscribe Topics.SUBSCRIPTIONS.ALL, {}
  ]
  data: ->
    groups: Tags.find({}, limit: Session.get "topicGroupsCount")

  onRun: ->
    $("body").on('arrivedAtBottom', ->
      currentTopicGroupsCount = Session.get "topicGroupsCount"
      if currentTopicGroupsCount < Tags.find().count()
        Session.set "topicGroupsCount", currentTopicGroupsCount + 3
    )
    @next()

  onStop: ->
    $("body").off('arrivedAtBottom')
)

homeRouter.helpers(
  $not: (boolean) -> not boolean
  fullDate: (date) -> moment(date).format('LL')
  readableLongNumber: (number) ->
    if not number?
      return ""

    text = number.toString()
    spacedNumber = ""
    offset = text.length % 3

    for position in [0 ... text.length]
      if (position - offset) % 3 is 0
        spacedNumber += " "
      spacedNumber += text[position]

    return spacedNumber
  topicsInList: (associatedTopicsList) ->
    Topics.find(_id: $in: associatedTopicsList.map (topic) -> topic._id)
  isSupportedByUser: (topicId) ->
    Meteor.user()? and topicId in Meteor.user().profile.supportedTopicIds
)

homeRouter.events(
  'click .toggle-support': (event) ->
    event.preventDefault()
    Meteor.call("toggleSupportTopic", event.currentTarget.dataset.topicId, (error, result) ->
      if error?
        if error.error is share.ERRORS.LOG_IN_REQUIRED
          alert "Please log in"
        else
          console.dir error
    )
)

@HomeRouter = homeRouter

Router.route(share.ROUTE.HOME,
  path: share.PATH.HOME
  controller: 'HomeRouter'
)