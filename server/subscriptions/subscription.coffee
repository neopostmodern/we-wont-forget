methods = {}

methods[share.METHODS.SUBSCRIBE_WITH_EMAIL] = (emailAddress) ->
  if not emailAddress.match(SimpleSchema.RegEx.Email)?
    throw new Meteor.Error 400, "Not an e-mail address"

  if Meteor.call share.METHODS.IS_SUBSCRIBED, emailAddress
    throw new Meteor.Error 400, "Already subscribed"

  subscription =
    email: emailAddress
    confirmed: false
    active: false


  userId = Meteor.userId()
  if userId?
    subscription.userId = userId
    Meteor.users.update({_id: userId},
      $set:
        'profile.subscriptionStatus': 'pending'
    )

  subscriptionId = Subscriptions.insert subscription

  Meteor.call 'email', {
    to: emailAddress
    subject: 'Confirm subscription to the Project "we won\'t forget"'
    text: "Poject \"We won't forget\"\n\nCONFIRM SUBSCRIPTION\nClick here to confirm: #{ Meteor.absoluteUrl() }_/confirmSubscription/#{ subscriptionId }\n\nBest,\nThe server" +
      "\n\nPS: Please remember that we're in beta. There is no actual subscription for now." +
      "\nPPS: There is no unsubscription built in for now. Write me instead: clemens@neopostmodern.com"
  }

methods[share.METHODS.IS_SUBSCRIBED] = (emailAddress) ->
  if not emailAddress.match(SimpleSchema.RegEx.Email)?
    throw new Meteor.Error 400, "Not an e-mail address"

  return Subscriptions.findOne(email: emailAddress)?


Meteor.methods(methods)