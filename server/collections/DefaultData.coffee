share.IncludeDefaultData = ->
  if not Tags.findOne(name: 'Untagged')?
    Meteor.call share.METHODS.ADD_TAG, { _id: 'untagged', name: 'Untagged', visibility: [ 'curator' ] }

Meteor.startup share.IncludeDefaultData