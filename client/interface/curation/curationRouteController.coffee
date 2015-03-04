curationRouter = RouteController.extend(
  template: 'curation'
  onBeforeAction: ->
    if not Roles.userIsInRole Meteor.userId(), 'curator'
      @render('access_denied')
      return

    @next()

  waitOn: -> [
    Meteor.subscribe Tags.SUBSCRIPTIONS.ALL, {}
    Meteor.subscribe Topics.SUBSCRIPTIONS.ALL, {}
  ]
  data: ->
    groups: Tags.find()
)

curationRouter.helpers(
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

curationRouter.events(
  'submit .create-topic': (event, template) ->
    event.preventDefault()

    Meteor.call('createTopic',
      name: template.find('.topic-title').value
      dateStarted: moment(template.find('.topic-start_date').value, "YYYY-MM-DD").toDate()
    , (error) ->
      console.dir error
    )
)

@CurationRouter = curationRouter

Router.route(share.ROUTE.CURATION,
  path: share.PATH.CURATION
  controller: 'CurationRouter'
)