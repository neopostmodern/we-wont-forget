homeRouter = RouteController.extend(
  template: 'home'
  waitOn: -> [
    Meteor.subscribe Tags.SUBSCRIPTIONS.ALL, {}
    Meteor.subscribe Topics.SUBSCRIPTIONS.ALL, {}
  ]
  data: ->
    groups: Tags.find()
#    groups: Tags.find().fetch().map (tag) ->   # forEach (tag) ->
#      console.log "Aggregating #{ tag.name }..."
#      return {
#        name: tag.name
#        associatedTopics: Topics.find(
#          _id: $in: tag.associatedTopics.map (topic) -> topic._id
#        )
#      }

#    groups: [
#      name: 'Global'
#      topics: [
#        name: 'NSA Scandal'
#        started: moment('3 jan 2013').toDate()
#        supporterCount: 12940
#      ,
#        name: 'Syrian War'
#        supporterCount: 1340
#      ]
#    ,
#      name: 'Germany'
#      topics: [
#        name: 'BER'
#        started: moment('12 oct 2012').toDate()
#        supporterCount: 10022940
#      ,
#        name: 'TIPP'
#        supporterCount: 140
#        isSupportedByUser: true
#      ]
#    ]
)

homeRouter.helpers(
  $not: (boolean) -> not boolean
  fullDate: (date) -> moment(date).format('LL')
  readableLongNumber: (number) ->
    if not number?
      return ""

    text = number.toString()
    spacedNumber = ""
    offset = text.length % 3

    for position in [0 ... text.length]
      if (position - offset) % 3 is 0
        spacedNumber += " "
      spacedNumber += text[position]

    return spacedNumber
  topicsInList: (associatedTopicsList) ->
    Topics.find(_id: $in: associatedTopicsList.map (topic) -> topic._id)
)

@HomeRouter = homeRouter

Router.route(share.ROUTE.HOME,
  path: share.PATH.HOME
  controller: 'HomeRouter'
)