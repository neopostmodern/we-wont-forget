#if Tag.documents.find().count() is 0
_randomInt = (upperLimit) -> Math.round(Math.random() * upperLimit)

checkRootAccess = (_this) ->
  Security.checkRole _this, 'admin', "Root access not granted"

Meteor.methods(
  reset: ->
    checkRootAccess(this)

    Meteor.call 'deleteEverything'
    Meteor.call 'createTestData'


  deleteEverything: ->
    checkRootAccess(this)

    Tags.remove({})
    Topics.remove({})
    Meteor.users.remove({})
    share.IncludeDefaultData()

  createTestData: ->
    checkRootAccess(this)

    TAG_COUNT = 10
    TOPIC_COUNT = 30
    TAGS_PER_TOPIC = 3

    console.log "Start adding development data..."

    for index in [0 .. TAG_COUNT]
      tagName = "tag_#{ index }"
      Tags.insert
        _id: tagName # hack: hardcode ids to ease debugging
        name: tagName
        associatedTopics: []
        visibility: ['all']


    for index in [0 .. TOPIC_COUNT]
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

    for topicIndex in [0 .. TOPIC_COUNT]
      topic = Topics.findOne "topic_" + topicIndex # ({}, skip: topicIndex - 1)
      tagIds = topic.tags.map((tag) -> tag._id)
      for tagIndex in [0 .. TAGS_PER_TOPIC - 1]
        randomTagId = "tag_" + _randomInt(TAG_COUNT - 1)
        if not (randomTagId in tagIds)
          Meteor.call 'tag', topic._id, randomTagId
          tagIds.push(randomTagId)

    console.log "Done."
)

Meteor.startup ->
  Meteor.users.find(
    'registered_emails.address': 'clemens@neopostmodern.com'
  ).forEach((user) ->
    Roles.addUsersToRoles(user._id, ['admin', 'curator', 'mod'])
  )
