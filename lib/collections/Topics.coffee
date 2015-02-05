#class Topic extends Document
#  @Meta
#    name: 'Topic'
#    fields: =>
#      tags: [ @ReferenceField Tag, ['name'] ]

Topics = new Mongo.Collection "topics"

Topics.SUBSCRIPTIONS =
  ALL: "subscriptions:topics/all"


@Topics = Topics

@Topics.attachSchema new SimpleSchema(
  name:
    type: String
    label: 'Topic name'
    max: 200
  supporterCount:
    type: Number
    min: 0
    label: 'Supporter count'
  tags:
    type: [ Object ]
    label: 'Tags'
    maxCount: 5
  'tags.$._id':
    type: String
    max: 20
    label: 'Tag ID'
  'tags.$.name':
    type: String
    label: 'Tag name'
    max: 50
)