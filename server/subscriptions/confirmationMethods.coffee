methods = {}

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

Meteor.methods(methods)