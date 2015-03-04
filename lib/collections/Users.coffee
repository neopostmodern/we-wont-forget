Schema = {}

Schema.UserProfile = new SimpleSchema(
  supportedTopicIds:
    type: [ String ]
    label: 'Supported Topic IDs'
  username:
    type: String
    label: 'Username (not necessarily unique)'
)

Schema.User = new SimpleSchema(
  emails:
    type: [ Object ]
    optional: true
  'emails.$.address':
    type: String
    regEx: SimpleSchema.RegEx.Email
  'emails.$.verified': type: Boolean
  createdAt: type: Date
  profile:
    type: Schema.UserProfile
    optional: true
  services:
    type: Object
    optional: true
    blackbox: true

  roles:
    type: [String],
    optional: true

)

Meteor.users.attachSchema Schema.User