#class @Tag extends Document
#  @Meta
#    name: 'Tag'
#    fields: =>
#      associatedTopics: [ @ReferenceField Topic, ['name', 'dateStarted', 'tags'] ]

tags = new Mongo.Collection "tags"


tags.SUBSCRIPTIONS =
  ALL: "subscriptions:tags/all"
  JOINED_WITH_TOPICS: "subscriptions:tags/with_topics"

tags.SCHEMA = new SimpleSchema(
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

  visibility:
    type: [ 'String' ]
    label: 'Visibility for roles'


  # todo: geo-tag
)

@Tags = tags

@Tags.attachSchema tags.SCHEMA