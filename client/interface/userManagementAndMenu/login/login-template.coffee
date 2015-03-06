Template.login.events(
  'submit #login-form': (event, template) ->
    event.preventDefault()
    Meteor.loginWithPassword(
      template.find('#login-mail').value,
      template.find('#login-password').value,
      (error) ->
        if error?
          Session.set LOGIN_ERROR, error.reason
          share.HELPERS.visualError(template.find('#login-section'))
        else
          closeLoginArea()
    )
)