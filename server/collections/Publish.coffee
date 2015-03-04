#Meteor.publish @Tags.SUBSCRIPTIONS.JOINED_WITH_TOPICS, (options) ->
#  options ?= {}
#
#  return Tags.find()

Meteor.publish Tags.SUBSCRIPTIONS.ALL, -> return Tags.find()
Meteor.publish Topics.SUBSCRIPTIONS.ALL, -> return Topics.find()

