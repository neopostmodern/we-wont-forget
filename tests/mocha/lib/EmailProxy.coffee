@MailProxy = new Meteor.Collection "_MailProxy"

Meteor.methods(
  'email': (mail) -> #todo: can't override / duplicate like this. research.
    mail.sent = moment()
    MailProxy.insert(mail)
  'searchInMailProxy': (query) -> MailProxy.find(query).fetch()
)