#@Topics.after.insert (userId, document) ->
#  @Tags.update(
#    _id: $in: document.tagIds
#  ,
#    $push: topicIds: @_id
#  )

Meteor.methods(
  createTopic: (topic) ->
    topic ?= {}
    topic.supporterCount = 0
    topic.tags ?= []

    check topic, Topics.SCHEMA

    if Roles.userIsInRole Meteor.userId(), 'curator'
      Topics.insert(topic)

  tag: (topicId, tagId) ->
    tag = Tags.findOne tagId
    topic = Topics.findOne topicId

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

  untag: (topicId, tagId) ->
    console.log "Untagging #{ topicId } from #{ tagId }"
    Topics.update topicId,
      $pull:
        tags:
          _id: tagId

    Tags.update tagId,
      $pull:
        associatedTopics:
          _id: topicId

  changeTagName: (tagId, newName) ->
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
      throw new Meteor.Error(share.ERRORS.LOG_IN_REQUIRED)

    if topicId in Meteor.user().profile.supportedTopicIds # toggle off
      Meteor.users.update(Meteor.userId(), $pull: 'profile.supportedTopicIds': topicId)
      Topics.update(topicId, $inc: supporterCount: -1)
    else # toggle on
      Meteor.users.update(Meteor.userId(), $push: 'profile.supportedTopicIds': topicId)
      Topics.update(topicId, $inc: supporterCount: 1)

#    Topics.update {'tags._id': tagId},
#      $pull:
#        tags:
#          _id: tagId



    # todo: update stored tag names in topics
    # Topics.update
)

# todo: topic tags change

# todo: user support change