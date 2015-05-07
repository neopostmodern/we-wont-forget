mailGun = new Mailgun(
  apiKey: Meteor.settings.email.mailgun.apiKey
)

Meteor.startup ->
  process.env.MAIL_URL = "smtp://#{ Meteor.settings.email.mailgun.username }:#{ Meteor.settings.email.mailgun.password }@smtp.mailgun.org"

Meteor.methods(
  "wwf.email": (email) ->
    email.from ?= "#{ Meteor.settings.email.from.name } <#{ Meteor.settings.email.from.emailAddress }>"

    # todo: mailgun doesn't work?
#    mailGun.send(
#      email
#    )

    Email.send(email)
)