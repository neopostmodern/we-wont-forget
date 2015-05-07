Meteor.methods

  clear: ->
    Meteor.users.remove {}
    Topics.remove {}
    Tags.remove {}
    Suggestions.remove {}