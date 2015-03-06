baseUrlToolRouter = RouteController.extend(
  template: "confirmation"
)

baseUrlToolRouter.helpers(
  ready: ->
    @state.get share.BaseUrlToolRouter.STATE.READY
  error: ->
    @state.get share.BaseUrlToolRouter.STATE.ERROR
  confirmMessage: ->
    @state.get share.BaseUrlToolRouter.STATE.CONFIRM_MESSAGE
)

baseUrlToolRouter.STATE =
  READY: 'ready'
  ERROR: 'error'
  CONFIRM_MESSAGE: 'confirmMessage'

share.BaseUrlToolRouter = baseUrlToolRouter