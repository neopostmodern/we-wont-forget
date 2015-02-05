#if Tag.documents.find().count() is 0
_randomInt = (upperLimit) -> Math.round(Math.random() * upperLimit)

Meteor.startup ->
  Tags.remove({})
  Topics.remove({})

  TAG_COUNT = 5
  TOPIC_COUNT = 30
  TAGS_PER_TOPIC = 3

  for index in [1 .. TAG_COUNT]
    Tags.insert
      name: "tag_#{ index }"
      associatedTopics: []


  for index in [1 .. TOPIC_COUNT]
    tag = Tags.findOne({}, {skip: index % TAG_COUNT})

    topicName = "topic_#{ index }"
    Topics.insert(
      name: topicName
      dateStarted: new Date(Date.now() - index * 100000000)
      tags: []
      supporterCount: Math.round(Math.random() * 10000)
    ,
      (error, _id) ->
        Meteor.call 'tag', _id, tag._id
    )

  for topicIndex in [1 ... TOPIC_COUNT]
    topic = Topics.findOne({}, skip: topicIndex)
    for tagIndex in [1 .. TAGS_PER_TOPIC - 1]
      tag = Tags.findOne({}, skip: _randomInt(TAG_COUNT - 1))
      Meteor.call 'tag', topic._id, tag._id
