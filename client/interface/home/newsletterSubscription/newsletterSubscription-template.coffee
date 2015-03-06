Template.newsletter_subscription.helpers(
  'userEligibleForSubscription': ->
    not Meteor.user()?.profile.subscriptionStatus?
  'userSubscriptionPending': ->
    Meteor.user()?.profile.subscriptionStatus is 'pending'
)

Template.newsletter_subscription.events(
  'submit form#newsletter-subscription': (event, template) ->
    event.preventDefault()

    emailAddress = share.HELPERS.userEmailAddress() ? template.find('.email').value

    Meteor.call share.METHODS.SUBSCRIBE_WITH_EMAIL, emailAddress, (error) ->
      if error?
        console.dir error
        share.HELPERS.visualError(template.find('#newsletter-subscription'))
     #todo: error handling
)