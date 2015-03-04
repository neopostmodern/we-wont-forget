LOGIN_FIELD_STATUS = 'loginFieldStatus'
STATUS_LOGIN = 'login'
STATUS_SIGNUP = 'signup'
STATUS_USER = 'user'

LOGIN_ERROR = 'login-error'


Template.user_and_navigation.helpers(
  isClosed: -> share.HELPERS.isRazorbladeModalClosed(LOGIN_FIELD_STATUS)
  isOpen: -> not share.HELPERS.isRazorbladeModalClosed(LOGIN_FIELD_STATUS)
  isLogin: -> Session.get(LOGIN_FIELD_STATUS) is STATUS_LOGIN
  isSignUp: -> Session.get(LOGIN_FIELD_STATUS) is STATUS_SIGNUP
  isUser: -> Session.get(LOGIN_FIELD_STATUS) is STATUS_USER

  actionTemplate: ->
    switch Session.get LOGIN_FIELD_STATUS
      when STATUS_LOGIN then 'login'
      when STATUS_SIGNUP then 'signup'
      when STATUS_USER then 'user'

  email: -> Meteor.user()?.emails[0].address
  loginError: -> Session.get LOGIN_ERROR
)

Template.user_and_navigation.events(
  'click .open-login-area': (event) ->
    Session.set LOGIN_FIELD_STATUS, STATUS_LOGIN
  'click .open-signup-area': (event) ->
    Session.set LOGIN_FIELD_STATUS, STATUS_SIGNUP
  'click .open-user-area': (event) ->
    Session.set LOGIN_FIELD_STATUS, STATUS_USER
  'click .close-login-area': (event) ->
    Session.set LOGIN_ERROR, null
    Session.set LOGIN_FIELD_STATUS, null

  'submit #login-form': (event, template) ->
    event.preventDefault()
    Meteor.loginWithPassword(
      template.find('#login-mail').value,
      template.find('#login-password').value,
      (error) ->
        if error?
          Session.set LOGIN_ERROR, error.reason
          template.find('#login-section').classList.add('animated-error')
          window.setTimeout(->
            template.find('#login-section').classList.remove('animated-error')
          , 600)
        else
          Session.set LOGIN_ERROR, null
          Session.set LOGIN_FIELD_STATUS, null
    )
  'click .logout-action': (event) ->
    event.preventDefault()
    Session.set LOGIN_FIELD_STATUS, null
    Meteor.logout()
)