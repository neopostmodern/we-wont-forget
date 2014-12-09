class @Tag extends Document
  @Meta
    name: 'Tag'
    fields: =>
      associatedTopics: [ @ReferenceField Topic, ['name', 'dateStarted', 'tags'] ]



Tag.SUBSCRIPTIONS =
  ALL: "subscriptions:tags/all"
  JOINED_WITH_TOPICS: "subscriptions:tags/with_topics"


#@Tag = Tag
#
#@Tags.attachSchema new SimpleSchema(
#  name:
#    type: String
#    label: 'Tag name'
#    max: 50
#  associatedTopicIds:
#    type: [ String ]
#    label: 'IDs of topics with this tag'
#)