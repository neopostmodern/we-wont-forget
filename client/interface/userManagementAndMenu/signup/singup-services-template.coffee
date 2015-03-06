Template.signup_services.events(
  'click #signup-services button.meteor': (event, template) ->
    Meteor.loginWithMeteorDeveloperAccount((error) ->
      if error?
        console.dir error #todo: what?
      else
        share.EscapeManager.close()
    )

  'click #signup-services button.facebook': (event, template) ->
    Meteor.loginWithFacebook((error) ->
      if error?
        console.dir error #todo: what?
      else
        share.EscapeManager.close()
    )
)