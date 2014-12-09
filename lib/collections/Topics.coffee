class Topic extends Document
  @Meta
    name: 'Topic'
    fields: =>
      tags: [ @ReferenceField Tag, ['name'] ]

Topic.SUBSCRIPTIONS =
  ALL: "subscriptions:topics/all"

@Topic = Topic