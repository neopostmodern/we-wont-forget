HOME_CURATION_STATUS = 'homeCurationStatus'
STATUS_ADD_TOPIC = 'addTopic'
STATUS_ADD_TAG = 'addTag'

Session.setDefault "topicGroupsCount", 3

homeRouter = share.BaseListRouter.extend(
  template: 'home'

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
  isHomeCurationClosed: -> share.HELPERS.isRazorbladeModalClosed(HOME_CURATION_STATUS)
  isHomeCurationOpen: -> not share.HELPERS.isRazorbladeModalClosed(HOME_CURATION_STATUS)

  homeCurationTemplateName: ->
    switch Session.get HOME_CURATION_STATUS
      when STATUS_ADD_TOPIC then "add_topic"
      when STATUS_ADD_TAG then "add_tag"
)

closeCurationRazorbladeModal = ->
  Session.set HOME_CURATION_STATUS, null

homeRouter.events(
  'click .home_curation-add-topic': ->
    Session.set HOME_CURATION_STATUS, STATUS_ADD_TOPIC
    share.EscapeManager.register(callback: closeCurationRazorbladeModal, group: 'home-curation')
  'click .home_curation-add-tag': ->
    Session.set HOME_CURATION_STATUS, STATUS_ADD_TAG
    share.EscapeManager.register(callback: closeCurationRazorbladeModal, group: 'home-curation')
)

@HomeRouter = homeRouter

Router.route(share.ROUTE.HOME,
  path: share.PATH.HOME
  controller: 'HomeRouter'
)