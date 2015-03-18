endSubscriptionRouter = share.BaseUrlToolRouter.extend(
  onBeforeAction: ->
    @state.set share.BaseUrlToolRouter.STATE.TASK_NAME, "End your subscription to the broadcast"

    Meteor.call(share.METHODS.END_SUBSCRIPTION, @params._id, (error, result) =>
      @state.set share.BaseUrlToolRouter.STATE.READY, true

      if error?
        @state.set share.BaseUrlToolRouter.STATE.ERROR, error.message # todo
      else
        @state.set share.BaseUrlToolRouter.STATE.MESSAGE, "You're subscription was stopped!"
    )

    @next()
)


@EndSubscriptionRouter = endSubscriptionRouter

Router.route(share.ROUTE.END_SUBSCRIPTION,
  path: share.PATH.END_SUBSCRIPTION
  controller: 'EndSubscriptionRouter'
)