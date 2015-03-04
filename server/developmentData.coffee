#if Tag.documents.find().count() is 0
_randomInt = (upperLimit) -> Math.round(Math.random() * upperLimit)

Meteor.startup ->
  Tags.remove({})
  Topics.remove({})
  Meteor.users.remove({})

  TAG_COUNT = 5
  TOPIC_COUNT = 30
  TAGS_PER_TOPIC = 3

  console.log "Start adding development data..."

  myUserId = Accounts.createUser(
    email: "clemens.schoell@yahoo.de"
    password: "banane"
    profile:
      username: "neo post modern"
      supportedTopicIds: []
  )

  Roles.addUsersToRoles(myUserId, ['admin', 'curator'])

  for index in [1 .. TAG_COUNT]
    tagName = "tag_#{ index }"
    Tags.insert
      _id: tagName # hack: hardcode ids to ease debugging
      name: tagName
      associatedTopics: []


  for index in [1 .. TOPIC_COUNT]
    tag = Tags.findOne({}, {skip: index % TAG_COUNT})

    topicName = "topic_#{ index }"
    Topics.insert(
      _id: topicName # hack: hardcode ids to ease debugging
      name: topicName
      dateStarted: new Date(Date.now() - index * 10000000000)
      tags: []
      supporterCount: Math.round(Math.random() * 10000)
    ,
      (error, _id) ->
        Meteor.call 'tag', _id, tag._id
    )

  console.log "Start tagging..."

#  for topicIndex in [1 .. TOPIC_COUNT]
#    topic = Topics.findOne({}, skip: topicIndex - 1)
#    console.log topic
#    for tagIndex in [1 .. TAGS_PER_TOPIC - 1]
#      randomTagId = _randomInt(TAG_COUNT - 1)
#      if (tag for tag in topic.tags when tag._id is randomTagId)
#        Meteor.call 'tag', topic._id, randomTagId

  console.log "Done."