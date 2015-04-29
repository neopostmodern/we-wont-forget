Meteor.methods(
  clear: ->
    Meteor.users.remove {}

  createUserInGroups: (roles) ->
    user =
      username: 'username'
      password: 'password'
      profile:
        username: 'username'

    user._id = Accounts.createUser(_.extend {}, user, pending: 0)

    Roles.addUsersToRoles user._id, roles

    return user
)