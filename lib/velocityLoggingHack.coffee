if Meteor.isServer
  if VelocityLogs? #hopefully this will get disabled during production
    Router.route 'log', ->
      if @request.method is 'OPTIONS'
        @response.setHeader 'Access-Control-Allow-Origin', '*'
        @response.setHeader 'Access-Control-Allow-Methods', 'POST, OPTIONS'
        @response.setHeader 'Access-Control-Max-Age', 1000
        @response.setHeader 'Access-Control-Allow-Headers', 'origin, x-csrftoken, content-type, accept'
        @response.end()

        return

      if @request.method is 'POST'
        logEntry = @request.body

        logEntry.level ?= 'unspecified'
        logEntry.framework ?= 'log hack'
        logEntry.timestamp ?= moment().format("HH:mm:ss.SSS")

        _id = VelocityLogs.insert(logEntry)

        @response.setHeader 'Access-Control-Allow-Origin', '*'
        @response.end(_id)

        return

    , where: 'server'


