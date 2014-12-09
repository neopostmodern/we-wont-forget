#if Tag.documents.find().count() is 0
_randomInt = (upperLimit) -> Math.round(Math.random() * upperLimit)

Meteor.startup ->
  Tag.documents.remove({})
  Topic.documents.remove({})

  TAG_COUNT = 5
  TOPIC_COUNT = 30
  TAGS_PER_TOPIC = 3

  for index in [1 .. TAG_COUNT]
    Tag.documents.insert
      name: "tag_#{ index }"
      associatedTopics: []


  for index in [1 .. TOPIC_COUNT]
    tag = Tag.documents.findOne({}, {skip: index % TAG_COUNT})

    topicName = "topic_#{ index }"
    Topic.documents.insert(
      name: topicName
      dateStarted: new Date(Date.now() - index * 100000000)
      tags: []
      supporterCount: 0
    ,
      (error, _id) ->
        Meteor.call 'tag', _id, tag._id
    )

  for topicIndex in [1 ... TOPIC_COUNT]
    topic = Topic.documents.findOne({}, skip: topicIndex)
    for tagIndex in [1 .. TAGS_PER_TOPIC - 1]
      tag = Tag.documents.findOne({}, skip: _randomInt(TAG_COUNT - 1))
      Meteor.call 'tag', topic._id, tag._id

  Document.defineAll()
