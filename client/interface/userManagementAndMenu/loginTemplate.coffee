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

closeLoginArea = ->
  Session.set LOGIN_ERROR, null
  Session.set LOGIN_FIELD_STATUS, null

Template.user_and_navigation.events(
  'click .open-login-area': (event) ->
    Session.set LOGIN_FIELD_STATUS, STATUS_LOGIN
    share.EscapeManager.register(callback: closeLoginArea, group: 'user-and-login')
  'click .open-signup-area': (event) ->
    Session.set LOGIN_FIELD_STATUS, STATUS_SIGNUP
    share.EscapeManager.register(callback: closeLoginArea, group: 'user-and-login')
  'click .open-user-area': (event) ->
    Session.set LOGIN_FIELD_STATUS, STATUS_USER
    share.EscapeManager.register(callback: closeLoginArea, group: 'user-and-login')
  'click .close-login-area': (event) ->
    closeLoginArea()

  'click .logout-action': (event) ->
    event.preventDefault()
    Meteor.logout()
    closeLoginArea()
)