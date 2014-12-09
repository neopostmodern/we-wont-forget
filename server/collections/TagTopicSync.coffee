#@Topics.after.insert (userId, document) ->
#  @Tags.update(
#    _id: $in: document.tagIds
#  ,
#    $push: topicIds: @_id
#  )

# todo: topic tags change

# todo: user support change