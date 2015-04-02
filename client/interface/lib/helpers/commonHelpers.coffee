share.HELPERS =
  isRazorbladeModalClosed: (sessionVariableName) ->
    not Session.get(sessionVariableName)? or
      Session.get(sessionVariableName).trim().length is 0
  activateDatepickers: (template, selector) ->
    template.findAll(selector ? '.datepicker').forEach((element) ->
      new Pikaday(
        field: element
        firstDay: 1 # monday
        maxDate: new Date()
      )
    )


share.HELPERS.userEmailAddress = ->
  Meteor.user()?.registered_emails?[0].address

share.HELPERS.visualError = (element) ->
  element.classList.add('animated-error')
  window.setTimeout(->
    element.classList.remove('animated-error')
  , 600)

Template.registerHelper "email", share.HELPERS.userEmailAddress

Template.registerHelper "userIsCurator", -> Roles.userIsInRole Meteor.userId(), "curator"
Template.registerHelper "userIs", (roleName) -> Roles.userIsInRole Meteor.userId(), roleName
Template.registerHelper "username", -> Meteor.user()?.profile.username

Template.registerHelper "fullDate", (date) -> moment(date).format('LL')
Template.registerHelper "readableLongNumber", (number) ->
  if not number?
    return ""

  text = number.toString()
  spacedNumber = ""
  offset = text.length % 3

  for position in [0 ... text.length]
    if (position - offset) % 3 is 0
      spacedNumber += " "
    spacedNumber += text[position]

  return spacedNumber