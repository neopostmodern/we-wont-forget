share.HELPERS =
  isRazorbladeModalClosed: (sessionVariableName) ->
    not Session.get(sessionVariableName)? or
      Session.get(sessionVariableName).trim().length is 0
  activateDatepickers: (template, selector) ->
    template.findAll(selector ? '.datepicker').forEach((element) ->
      new Pikaday(
        field: element
        firstDay: 1 # monday
        maxDate: new Date()
      )
    )


share.HELPERS.userEmailAddress = ->
  Meteor.user()?.registered_emails?[0].address

Template.registerHelper "email", share.HELPERS.userEmailAddress

Template.registerHelper "userIsCurator", -> Roles.userIsInRole Meteor.userId(), "curator"
Template.registerHelper "userIs", (roleName) -> Roles.userIsInRole Meteor.userId(), roleName
Template.registerHelper "username", -> Meteor.user()?.profile.username