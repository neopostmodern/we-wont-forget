#@Topics.after.insert (userId, document) ->
#  @Tags.update(
#    _id: $in: document.tagIds
#  ,
#    $push: topicIds: @_id
#  )

Meteor.methods(
  tag: (topicId, tagId) ->
    tag = Tag.documents.findOne tagId
    topic = Topic.documents.findOne topicId

    Topic.documents.update topic._id,
      $push:
        tags:
          _id: tag._id
          name: tag.name

    Tag.documents.update tag._id,
      $push:
        associatedTopics:
          _id: topic._id
          name: topic.name
)

# todo: topic tags change

# todo: user support change