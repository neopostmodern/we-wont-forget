@Security =
  isServerSideCall: -> not @connection?
  checkRole: (roleName, errorText) ->
    if not (Roles.userIsInRole(Meteor.userId(), roleName) or Security.isServerSideCall())
      throw new Meteor.Error 403, errorText
    return