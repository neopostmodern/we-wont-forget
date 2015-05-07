@Security =
  isServerSideCall: (_this) ->
    if not _this?
      false
    else
      not _this.connection?

  ###
  @param _this Original context of connection, required for server-side call pass-all (use null to disable)
  ###
  checkRole: (_this, roleName, errorText) ->
    if not (Roles.userIsInRole(Meteor.userId(), roleName) and not Security.isServerSideCall(_this))
      throw new Meteor.Error 403, errorText
    return


  ###
  Throws a 403 exception if user is not logged in.

  @param {Object} _this Original context of connection, required for server-side call pass-all (use null to disable)
  @param {String} errorText Description text to throw upon failure

  @return undefined
  ###
  checkLoggedIn: (_this, errorText) ->
    if not Meteor.userId()? and not Security.isServerSideCall(_this)
      throw new Meteor.Error 403, errorText
    return