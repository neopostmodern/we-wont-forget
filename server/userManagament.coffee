Accounts.onCreateUser((options, user) ->
  console.dir options
  console.dir user

  user.profile =
    supportedTopicIds: []
    username: options.profile.name ? options.profile.username

  console.dir user

  return user
)