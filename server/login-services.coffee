ServiceConfiguration.configurations.upsert(
  { service: 'meteor-developer' },
  {
    $set: {
      clientId: Meteor.settings.authenticationProviders.meteor.appId,
      secret: Meteor.settings.authenticationProviders.meteor.appSecret,
      loginStyle: 'popup'
    }
  }
)