sendVerificationMail = (pendingKey) ->
  Meteor.setTimeout(->
    console.log pendingKey
    userId = Meteor.users.findOne('pending.key': pendingKey)._id
    Accounts.sendVerificationEmail(userId)
    console.log "confirmation send"
  , 3000)


Accounts.onCreateUser((options, user) ->
  console.dir options
  console.dir user

  user.profile =
    supportedTopicIds: []
    username: options.profile?.name ? options.profile?.username

  if options.pending
    pendingKey = Meteor.uuid()
    user.pending =
      status: true
      key: pendingKey
    sendVerificationMail(pendingKey)

  return user
)