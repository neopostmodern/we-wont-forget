baseUrlToolRouter = RouteController.extend(
  template: "url_tool_request"
)

baseUrlToolRouter.helpers(
  ready: ->
    @state.get share.BaseUrlToolRouter.STATE.READY
  error: ->
    @state.get share.BaseUrlToolRouter.STATE.ERROR
  message: ->
    @state.get share.BaseUrlToolRouter.STATE.MESSAGE
  taskName: ->
    @state.get share.BaseUrlToolRouter.STATE.TASK_NAME
)

baseUrlToolRouter.STATE =
  READY: 'ready'
  ERROR: 'error'
  MESSAGE: 'message'
  TASK_NAME: 'taskName'

share.BaseUrlToolRouter = baseUrlToolRouter