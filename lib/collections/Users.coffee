Schema = {}

Schema.UserProfile = new SimpleSchema(
  supportedTopicIds:
    type: [ String ]
    maxCount: 1000
    label: 'Supported Topic IDs'
  username:
    type: String
    label: 'Username (not necessarily unique)'
  subscriptionStatus:
    type: String
    label: 'Status of subscription'
    optional: true
)

Schema.User = new SimpleSchema(
  emails:
    type: [ Object ]
    optional: true
  'emails.$.address':
    type: String
    regEx: SimpleSchema.RegEx.Email
  'emails.$.verified':
    type: Boolean
  createdAt: type: Date
  profile:
    type: Schema.UserProfile
    optional: true
  services:
    type: Object
    optional: true
    blackbox: true

  roles:
    type: [String]
    optional: true

  registered_emails:
    type: [ Object ]
    optional: true
  'registered_emails.$.address':
    type: String
    regEx: SimpleSchema.RegEx.Email
  'registered_emails.$.verified':
    type: Boolean

  pending:
    type: Object
    optional: true
  'pending.status':
    type: Boolean
  'pending.key':
    type: String
)

Meteor.users.attachSchema Schema.User

Meteor.users.SUBSCRIPTIONS =
  OWN_PROFILE: 'userProfileSubscription'