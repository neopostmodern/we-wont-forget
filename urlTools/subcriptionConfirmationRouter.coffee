confirmSubscriptionRouter = share.BaseUrlToolRouter.extend(
  onBeforeAction: ->
    @state.set share.BaseUrlToolRouter.STATE.TASK_NAME, "Subscription to broadcast"

    Meteor.call('confirmSubscription', @params._id, (error, result) =>
      @state.set share.BaseUrlToolRouter.STATE.READY, true

      if error?
        @state.set share.BaseUrlToolRouter.STATE.ERROR, error # todo
      else
        @state.set share.BaseUrlToolRouter.STATE.MESSAGE, "Subscription confirmed!"
    )

    @next()
)


@ConfirmSubscriptionRouter = confirmSubscriptionRouter

Router.route(share.ROUTE.CONFIRM_SUBSCRIPTION,
  path: share.PATH.CONFIRM_SUBSCRIPTION
  controller: 'ConfirmSubscriptionRouter'
)