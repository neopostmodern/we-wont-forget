#@Topics.after.insert (userId, document) ->
#  @Tags.update(
#    _id: $in: document.tagIds
#  ,
#    $push: topicIds: @_id
#  )

Meteor.methods(
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
)

# todo: topic tags change

# todo: user support change