
Session.setDefault "topicGroupsCount", 3

tagRouter = share.BaseListRouter.extend(
  template: 'tag'
  data: ->
    groups: Tags.find({ _id: @params._id })
    selectedTag: Tags.findOne @params._id
)

@TagRouter = tagRouter

Router.route(share.ROUTE.TAG,
  path: share.PATH.TAG
  controller: 'TagRouter'
)