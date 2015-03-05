#@Topics.after.insert (userId, document) ->
#  @Tags.update(
#    _id: $in: document.tagIds
#  ,
#    $push: topicIds: @_id
#  )

isServerSideCall = -> not @connection?

methods =
  tag: (topicId, tagId) ->
    if not Roles.userIsInRole(Meteor.userId(), 'curator') or isServerSideCall()
      throw new Meteor.Error 403

    tag = Tags.findOne tagId
    topic = Topics.findOne topicId

    if not tag?
      throw new Meteor.Error "Unknown tag identifier '#{ tagId }'"
    if not topic?
      throw new Meteor.Error "Unknown topic identifier '#{ tagId }'"

    if topic.tags.filter((t) -> t._id is tag._id).length > 0
      throw new Meteor.Error "Already tagged topic '#{ topic.name }' (#{ topic._id }) with tag '#{ tag.name }' (#{ tag._id })"

    Topics.update topic._id,
      $push:
        tags:
          _id: tag._id
          name: tag.name

    Tags.update tag._id,
      $push:
        associatedTopics:
          _id: topic._id
          name: topic.name

    if tagId isnt 'untagged' and topic.tags.filter((t) -> t._id is 'untagged').length > 0
      Meteor.call 'untag', topicId, 'untagged'


  untag: (topicId, tagId) ->
    if not Roles.userIsInRole(Meteor.userId(), 'curator') or isServerSideCall()
      throw new Meteor.Error 403

    console.log "Untagging #{ topicId } from #{ tagId }"

    tag = Tags.findOne tagId
    topic = Topics.findOne topicId

    if not tag?
      throw new Meteor.Error "Unknown tag identifier '#{ tagId }'"
    if not topic?
      throw new Meteor.Error "Unknown topic identifier '#{ tagId }'"

    Topics.update topicId,
      $pull:
        tags:
          _id: tagId

    Tags.update tagId,
      $pull:
        associatedTopics:
          _id: topicId

    if (topic.tags.length - 1) is 0 #deleted last tag
      Meteor.call 'tag', topicId, 'untagged'

  changeTagName: (tagId, newName) ->
    if not Roles.userIsInRole('curator') or isServerSideCall()
      throw new Meteor.Error 403

    Tags.update tagId,
      name: newName

    Topics.find('tags._id': tagId).forEach (topic) ->
      Topics.update topic._id
        $pull:
          tags:
            _id: tagId
      Topics.update topic._id
        $push:
          tags:
            _id: tagId
            name: newName

  toggleSupportTopic: (topicId) ->
    check topicId, String

    if not Meteor.userId()?
      throw new Meteor.Error(401, share.ERRORS.LOG_IN_REQUIRED)

    if topicId in Meteor.user().profile.supportedTopicIds # toggle off
      Meteor.users.update(Meteor.userId(), $pull: 'profile.supportedTopicIds': topicId)
      Topics.update(topicId, $inc: supporterCount: -1)
    else # toggle on
      Meteor.users.update(Meteor.userId(), $push: 'profile.supportedTopicIds': topicId)
      Topics.update(topicId, $inc: supporterCount: 1)

methods[share.METHODS.ADD_TAG] = (tag) ->
  tag ?= {}
  _id = tag._id
  delete tag._id
  tag.associatedTopics = []

  tag.visibility ?= ['all']

  if not (isServerSideCall() or tag.visibility.filter((role) -> not Roles.userIsInRole(Meteor.userId(), role)).length is 0)
    throw new Meteor.Error(403, "User not  allowed to specify this visibility constraint.")

  check tag, Tags.SCHEMA

  if Tags.find(name: tag.name).count() > 0
    throw new Meteor.Error("Duplicate tag name")

  if isServerSideCall() and _id?
    tag._id = _id

  Tags.insert(tag)

methods['createTopic'] = (topic) ->
  if not Roles.userIsInRole(Meteor.userId(), 'curator') or isServerSideCall()
    throw new Meteor.Error 403

  topic ?= {}
  topic.supporterCount = 0
  topic.tags ?= []

  check topic, Topics.SCHEMA

  if Roles.userIsInRole Meteor.userId(), 'curator'
    topicId = Topics.insert(topic)

    Meteor.call 'tag', topicId, 'untagged'

Meteor.methods(methods)

#    Topics.update {'tags._id': tagId},
#      $pull:
#        tags:
#          _id: tagId



    # todo: update stored tag names in topics
    # Topics.update


# todo: topic tags change

# todo: user support change