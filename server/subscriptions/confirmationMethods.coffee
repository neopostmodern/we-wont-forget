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

  return true

Meteor.methods(methods)