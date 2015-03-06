mailGun = new Mailgun(
  apiKey: Meteor.settings.email.mailgun.apiKey
)

Meteor.startup ->
  process.env.MAIL_URL = "smtp://#{ Meteor.settings.email.mailgun.username }:#{ Meteor.settings.email.mailgun.password }@smtp.mailgun.org"

Meteor.methods(
  'email': (email) ->
    email.from ?= 'clemens@neopostmodern.com' #todo: actual e-mail address!

    # todo: mailgun doesn't work?
#    mailGun.send(
#      email
#    )

    Email.send(email)
)