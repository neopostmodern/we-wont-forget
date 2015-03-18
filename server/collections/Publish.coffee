Meteor.publish Meteor.users.SUBSCRIPTIONS.OWN_PROFILE, ->
  if @userId
    if Roles.userIsInRole(@userId, 'admin')
      Meteor.users.find() #todo: move into separate subscription
    else
      Meteor.users.find({ _id: @userId }, fields: { profile: 1, registered_emails: 1 })
  else
    []

Tags.QUERY =
  forUser: (userId) ->
    roles = Roles.getRolesForUser(@userId)
    roles.push('all')

    return Tags.find({ visibility: $in: roles }, fields: { visibility: 0 })

Meteor.publish Tags.SUBSCRIPTIONS.ALL, ->
  Tags.QUERY.forUser(@userId)

Topics.QUERY =
  forUser: (userId, options) ->
    options ?= {}

    filter = {}
    if not Roles.userIsInRole(userId, 'curator')
      filter['tags.0'] = $exists: true # check that they're tagged

    return Topics.find(filter, options)

Meteor.publish Topics.SUBSCRIPTIONS.ALL, ->
  Topics.QUERY.forUser(@userId)

