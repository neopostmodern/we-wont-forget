#if Tag.documents.find().count() is 0
Meteor.startup ->
  Tag.documents.remove({})
  Topic.documents.remove({})

  for index in [1 .. 10]
    Tag.documents.insert
      name: "tag_#{ index }"


  for index in [1 .. 100]
    tag = Tag.documents.findOne({}, {skip: index % 10})

    Topic.documents.insert
      name: "topic_#{ index }"
      dateStarted: new Date(Date.now() - index * 100000000)
      tag:
        _id: tag._id
        name: tag.name
      supporterCount: 0

  Document.defineAll()

  for index in [1 .. 100]
    tag = Tag.documents.findOne({}, {skip: (index + 1) % 10})
    topic = Topic.documents.findOne({}, {skip: index % 10})


    Topic.documents.update topic._id,
      $set:
        name: topic.name + '-update'
#      $push:
#        tag:
#          _id: tag._id
#          name: tag.name

  console.log 'Associated Topics [#1]:'
  console.dir Tag.documents.findOne().associatedTopics
