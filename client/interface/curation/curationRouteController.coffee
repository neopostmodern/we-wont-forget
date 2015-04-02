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
  topicsInList: (associatedTopicsList) ->
    Topics.find(_id: $in: associatedTopicsList.map (topic) -> topic._id)
  isSupportedByUser: (topicId) ->
    Meteor.user()? and topicId in Meteor.user().profile.supportedTopicIds
)

@CurationRouter = curationRouter

Router.route(share.ROUTE.CURATION,
  path: share.PATH.CURATION
  controller: 'CurationRouter'
)