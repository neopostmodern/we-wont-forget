mailGun = new Mailgun(
  apiKey: Meteor.settings.email.mailgun.apiKey
)

Meteor.startup ->
  process.env.MAIL_URL = "smtp://postmaster%40sandboxc92c966545074009b332a8f02d0e7fb4.mailgun.org:#{ Meteor.settings.email.mailgun.password }@smtp.mailgun.org"

Meteor.methods(
  'email': (email) ->
    mailGun.send(
      email
    )
)