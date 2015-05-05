#class Topic extends Document
#  @Meta
#    name: 'Topic'
#    fields: =>
#      tags: [ @ReferenceField Tag, ['name'] ]

topics = new Mongo.Collection "topics"

topics.SUBSCRIPTIONS =
  ALL: "subscriptions:topics/all"

topics.SCHEMA = new SimpleSchema(
  name:
    type: String
    label: 'Topic name'
    max: 200
  supporterCount:
    type: Number
    min: 0
    label: 'Supporter count'
  dateStarted:
    type: Date
    label: 'Date started'
    optional: true
  tags:
    type: [ Object ]
    label: 'tags'
    maxCount: 5
  'tags.$._id':
    type: String
    max: 20
    label: 'Tag ID'
  'tags.$.name':
    type: String
    label: 'Tag name'
    max: 50
  wikipediaPageId:
    type: String
    label: 'Wikipedia Page ID'
    max: 50
    optional: true
)

@Topics = _.extend @Topics ? {}, topics

@Topics.attachSchema @Topics.SCHEMA