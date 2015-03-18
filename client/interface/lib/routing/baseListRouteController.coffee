baseListRouter = RouteController.extend(
  loadingTemplate: 'loading'
  waitOn: -> [
    Meteor.subscribe Tags.SUBSCRIPTIONS.ALL, {}
    Meteor.subscribe Topics.SUBSCRIPTIONS.ALL, {}
  ]
)

baseListRouter.helpers(
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
  supportedTopicsCount: ->
    Meteor.user()?.profile.supportedTopicIds.length
)

baseListRouter.events(
  'click .toggle-support': (event) ->
    event.preventDefault()
    Meteor.call("toggleSupportTopic", event.currentTarget.dataset.topicId, (error, result) ->
      if error?
        if error.error is share.ERRORS.LOG_IN_REQUIRED
          alert "Please log in"
        else
          console.dir error
    )

  'click .add-mini-tag': (event, template) ->
    Session.set share.SESSION.TOPIC_ID_FOR_MINI_TAG, event.currentTarget.dataset.topicId
    share.Modal.openCustomDialog('mini_select_tag')

  'submit form#suggest-topic': (event, template) ->
    event.preventDefault()


    suggestedTopic =
      title: template.find('input.title').value.trim()
      description: template.find('textarea.description').value

    dateString = template.find('input.date').value.trim()
    if dateString.length isnt 0
      suggestedTopic.dateStarted = new moment(dateString, 'YYYY-MM-DD').toDate()

    Meteor.call(share.METHODS.SUGGEST_TOPIC, suggestedTopic, (error) ->
      if error?
        console.dir error
      else
        alert "Thank you"
    )
)

share.BaseListRouter = baseListRouter