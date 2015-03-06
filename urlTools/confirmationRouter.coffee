confirmSubscriptionRouter = share.BaseUrlToolRouter.extend(
  onBeforeAction: ->
    Meteor.call('confirmSubscription', @params._id, (error, result) =>
      @state.set share.BaseUrlToolRouter.STATE.READY, true

      if error?
        @state.set share.BaseUrlToolRouter.STATE.ERROR, error # todo
      else
        @state.set share.BaseUrlToolRouter.STATE.CONFIRM_MESSAGE, "Subscription confirmed!"
    )

    @next()
)


@ConfirmSubscriptionRouter = confirmSubscriptionRouter

Router.route(share.ROUTE.CONFIRM_SUBSCRIPTION,
  path: share.PATH.CONFIRM_SUBSCRIPTION
  controller: 'ConfirmSubscriptionRouter'
)