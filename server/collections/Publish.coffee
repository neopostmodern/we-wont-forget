#Meteor.publish @Tags.SUBSCRIPTIONS.JOINED_WITH_TOPICS, (options) ->
#  options ?= {}
#
#  return Tags.find()

Meteor.publish Tag.SUBSCRIPTIONS.ALL, -> return Tag.documents.find()
Meteor.publish Topic.SUBSCRIPTIONS.ALL, -> return Topic.documents.find()

