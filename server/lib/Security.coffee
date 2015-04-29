@Security =
  isServerSideCall: (_this) -> not _this.connection?

  ###
  @param _this Original context of connection, required for server-side call pass-all (use null to disable)
  ###
  checkRole: (_this, roleName, errorText) ->
    if not (Roles.userIsInRole(Meteor.userId(), roleName) or Security.isServerSideCall(_this))
      throw new Meteor.Error 403, errorText
    return