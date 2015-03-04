#Meteor.publish @Tags.SUBSCRIPTIONS.JOINED_WITH_TOPICS, (options) ->
#  options ?= {}
#
#  return Tags.find()

Meteor.publish Tags.SUBSCRIPTIONS.ALL, ->
  roles = Roles.getRolesForUser(@userId)
  roles.push('all')
  console.dir roles
  return Tags.find({ visibility: $in: roles }, fields: { visibility: 0 })
Meteor.publish Topics.SUBSCRIPTIONS.ALL, ->
  filter = {}
  if not Roles.userIsInRole(@userId, 'curator')
    filter['tags.0'] = $exists: true # check that they're tagged
  return Topics.find()

