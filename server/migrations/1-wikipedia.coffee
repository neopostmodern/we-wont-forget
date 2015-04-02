#Migrations.add(
#  version: 1
#  name: 'Add Wikipedia Page ID field with default null to all topics'
#
#  up: ->
#    Topics.update({ $not: $exists: 'wikipediaPageId' }, { $set: wikipediaPageId: null }, { validate: false }, { multi: true })
#  down: ->
#    Topics.update({}, { $unset: wikipediaPageId: null }, { validate: false }, { multi: true })
#
#)