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
ServiceConfiguration.configurations.upsert(
  { service: 'facebook' },
  {
    $set: {
      appId: Meteor.settings.authenticationProviders.facebook.appId,
      secret: Meteor.settings.authenticationProviders.facebook.appSecret,
      loginStyle: 'popup'
    }
  }
)