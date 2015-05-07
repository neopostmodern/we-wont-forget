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

  Meteor.call 'wwf.email', {
    to: emailAddress
    subject: 'Confirm subscription to the Project "we won\'t forget"'
    text: "Poject \"We won't forget\"\n\nCONFIRM SUBSCRIPTION\nClick here to confirm: #{ Meteor.absoluteUrl() }_/confirmSubscription/#{ subscriptionId }\n\nBest,\nThe server"
  }

methods[share.METHODS.IS_SUBSCRIBED] = (emailAddress) ->
  if not emailAddress.match(SimpleSchema.RegEx.Email)?
    throw new Meteor.Error 400, "Not an e-mail address"

  return Subscriptions.findOne(email: emailAddress)?



methods[share.METHODS.CONFIRM_SUBSCRIPTION] = (pendingSubscriptionId) ->
  subscription = Subscriptions.findOne pendingSubscriptionId

  if not subscription?
    throw new Meteor.Error 404, "No subscription found."

  Subscriptions.update(
    _id: subscription._id
  ,
    $set:
      confirmed: true
      active: true
  )

  if subscription.userId?
    Meteor.users.update({ _id: subscription.userId },
      $set:
        'profile.subscriptionStatus': 'active'
    )

  return true

methods[share.METHODS.END_SUBSCRIPTION] = (subscriptionId) ->
  console.log "END SUB TO BROADCAST FOR " + subscriptionId

  check subscriptionId, String

  subscription = Subscriptions.findOne subscriptionId

  if not subscription?
    throw new Meteor.Error 404, "No subscription found."

  Subscriptions.update(
    _id: subscription._id
  ,
    $set:
      active: false
  )

  if subscription.userId?
    Meteor.users.update({ _id: subscription.userId },
      $set:
        'profile.subscriptionStatus': 'deactivated'
    )

  return true

# todo: re-subscribe


Meteor.methods(methods)