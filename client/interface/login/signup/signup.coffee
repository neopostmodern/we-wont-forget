Template.signup.events(
  'submit form.signup': (event, template) ->
    event.preventDefault()

    email = template.find('.email').value
    password = template.find('.password').value.trim()
    repeatPassword = template.find('.password-repeat').value.trim()

    if password isnt repeatPassword
      alert "passwords unequal"
      return

    if not email.match(SimpleSchema.RegEx.Email)?
      alert "not an email"
      return

    Accounts.createUser(
      email: email
      password: password
      profile:
        username: template.find('.username').value ? email
      pending: 1
    )

  'click #signup-services button.meteor': (event, template) ->
    Meteor.loginWithMeteorDeveloperAccount((error) ->
      if error?
        console.dir error #todo: what?
      else
        share.EscapeManager.close()
    )
)