share.HELPERS =
  isRazorbladeModalClosed: (sessionVariableName) ->
    not Session.get(sessionVariableName)? or
      Session.get(sessionVariableName).trim().length is 0


Template.registerHelper "email", -> Meteor.user()?.emails[0].address

Template.registerHelper "userIsCurator", -> Roles.userIsInRole Meteor.userId(), "curator"
Template.registerHelper "userIs", (roleName) -> Roles.userIsInRole Meteor.userId(), roleName
Template.registerHelper "username", -> Meteor.user()?.profile.username