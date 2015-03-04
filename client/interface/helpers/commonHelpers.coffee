UI.registerHelper "email", -> Meteor.user()?.emails[0].address

UI.registerHelper "userIsCurator", -> Roles.userIsInRole Meteor.userId(), "curator"