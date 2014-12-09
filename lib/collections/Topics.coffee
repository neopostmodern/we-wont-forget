class Topic extends Document
  @Meta
    name: 'Topic'
    fields: =>
      tag: @ReferenceField Tag, ['name']


class Topic extends Topic
  @Meta
    name: 'Topic'
    replaceParent: true
    fields: (fields) =>
      fields.tag = @ReferenceField Tag, ['name', 'dateStarted'], true, 'associatedTopics', ['name']
      return fields

Topic.SUBSCRIPTIONS =
  ALL: "subscriptions:topics/all"

@Topic = Topic