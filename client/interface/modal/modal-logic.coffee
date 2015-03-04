MODAL_IS_OPEN = 'modalIsOpen'
MODAL_TEMPLATE_NAME = 'modalTemplateName'
# Session.setDefault MODAL_IS_OPEN, true

Template.modal.events(
)

Template.modal.helpers(
  modalIsOpen: ->
    Session.get MODAL_IS_OPEN
  modalTemplateName: ->
    Session.get MODAL_TEMPLATE_NAME
)

internalClose = ->
  Session.set MODAL_IS_OPEN, false
  $('body').off('escapeKey')

internalOpen = ->
  Session.set MODAL_IS_OPEN, true
  $('body').on('escapeKey', internalClose)


share.Modal =
  openCustomDialog: (templateName) ->
    internalOpen()
    Session.set MODAL_TEMPLATE_NAME, templateName
  close: ->
    internalClose()