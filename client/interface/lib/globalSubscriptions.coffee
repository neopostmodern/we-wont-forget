Meteor.startup ->
  Deps.autorun ->
    Meteor.subscribe Meteor.users.SUBSCRIPTIONS.OWN_PROFILE