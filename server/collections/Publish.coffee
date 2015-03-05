#Meteor.publish @Tags.SUBSCRIPTIONS.JOINED_WITH_TOPICS, (options) ->
#  options ?= {}
#
#  return Tags.find()

Meteor.publish Meteor.users.SUBSCRIPTIONS.OWN_PROFILE, ->
  if @userId
    if Roles.userIsInRole(@userId, 'admin')
      Meteor.users.find()
    else
      console.dir Meteor.users.find({ _id: @userId }, fields: { profile: 1, registered_emails: 1 }).fetch()
      Meteor.users.find({ _id: @userId }, fields: { profile: 1, registered_emails: 1 })
  else
    []

Meteor.publish Tags.SUBSCRIPTIONS.ALL, ->
  roles = Roles.getRolesForUser(@userId)
  roles.push('all')

  return Tags.find({ visibility: $in: roles }, fields: { visibility: 0 })

Meteor.publish Topics.SUBSCRIPTIONS.ALL, ->
  filter = {}
  if not Roles.userIsInRole(@userId, 'curator')
    filter['tags.0'] = $exists: true # check that they're tagged
  return Topics.find()

