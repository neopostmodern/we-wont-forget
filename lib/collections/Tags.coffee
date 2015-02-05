#class @Tag extends Document
#  @Meta
#    name: 'Tag'
#    fields: =>
#      associatedTopics: [ @ReferenceField Topic, ['name', 'dateStarted', 'tags'] ]

Tags = new Mongo.Collection "tags"


Tags.SUBSCRIPTIONS =
  ALL: "subscriptions:tags/all"
  JOINED_WITH_TOPICS: "subscriptions:tags/with_topics"


@Tags = Tags

@Tags.attachSchema new SimpleSchema(
  name:
    type: String
    label: 'Tag name'
    max: 50
  associatedTopics:
    type: [ Object ]
    label: 'Topics with this tag'
  'associatedTopics.$._id':
    type: String
    max: 20
    label: 'Topic ID'
  'associatedTopics.$.name':
    type: String
    label: 'Topic name'
    max: 200
)