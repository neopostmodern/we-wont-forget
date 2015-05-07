if Meteor.isServer
  Meteor.methods(
    createUserInGroups: (roles, options) ->
      options = _.defaults (options ? {}), {
        hasUsername: true
        hasEmail: true
      }

      user =
        password: TestUtility.GenerateRandomStringFor 'password'
        profile:
          username: TestUtility.GenerateRandomStringFor 'username'

      if options.hasUsername
        user.username = 'username'

      if options.hasEmail
        user.emails = [
          address: TestUtility.GenerateRandomEmail()
          verified: true
        ]

      user._id = Accounts.createUser(_.extend {}, user, pending: 0)

      Roles.addUsersToRoles user._id, roles

      return user
  )