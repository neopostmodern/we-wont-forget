pendingUsers = new Mongo.Collection 'pendingUsers'

pendingUsers.SCHEMA = new SimpleSchema(
  username:
    type: String
    label: 'Username (not necessarily unique)'
  email:
    type: String
    regEx: SimpleSchema.RegEx.Email
)

pendingUsers.attachSchema(pendingUsers.SCHEMA)

@PendingUsers = pendingUsers