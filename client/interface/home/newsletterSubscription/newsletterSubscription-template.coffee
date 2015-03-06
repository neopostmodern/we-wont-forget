Template.newsletter_subscription.events(
  'submit form#newsletter-subscription': (event, template) ->
    event.preventDefault()

    emailAddress = share.HELPERS.userEmailAddress() ? template.find('.email').value

    Meteor.call share.METHODS.SUBSCRIBE_WITH_EMAIL, emailAddress, (error) ->
      if error?
        console.dir error
      else
        alert "You're subscribed.\nConfirm your e-mail to complete."
     #todo: error handling
)