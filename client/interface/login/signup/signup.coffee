Template.signup.events(
  'click #signup-services button.meteor': (event, template) ->
    Meteor.loginWithMeteorDeveloperAccount((error) ->
      if error?
        console.dir error #todo: what?
      else
        share.EscapeManager.close()
    )
)