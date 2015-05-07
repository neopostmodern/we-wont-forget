# http://stackoverflow.com/questions/30080348/override-redefine-meteor-methods/30084452

if Meteor.isServer
  SEND_EMAILS_DURING_TESTING = false

  MailProxy = new Meteor.Collection "_MailProxy"

  Meteor.startup ->
    Meteor.call('setupMailProxy')

  Meteor.methods(
    'setupMailProxy': ->
      _super = Email.send

      Email.send = (mail) ->
        if SEND_EMAILS_DURING_TESTING
          _super(mail)

        mail.sent = moment().toDate()
        MailProxy.insert(mail)

    'clearMailProxy': ->
      MailProxy.remove {}

    'searchInMailProxy': (query) -> MailProxy.find(query).fetch()
  )