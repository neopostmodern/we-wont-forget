_randomInt = (upperLimit) -> Math.round(Math.random() * upperLimit)

Meteor.methods(
  generateBroadcastForUserAsMarkdown: (subscriptionId) ->
    Security.checkRole this, 'admin'

    subscription = Subscriptions.findOne subscriptionId

    # hack: very inefficient
    topics = Topics.QUERY.forUser(subscription?.userId).fetch()
    topic_count = Math.min(topics.length, 10)
    # tags = Tags.QUERY.forUser(userId)

    topics_text = (topics[_randomInt(topics.length - 1)] for i in [0...topic_count])
      .map((topic) ->
        "* #{topic.name} *\[#{ topic.tags.map((tag) -> tag.name).join(", ") }]*"
      )
      .join("\n")

    text =  """
            *#{ moment().format('LL') }, #{ moment().format('wo') } issue of #{ moment().format('YYYY') }*

            we won't forget - weekly broadcast
            ==================================

            #{ topic_count } randomly selected topics
            ---------------------------
            #{topics_text}

            See all at [we won't forget](#{ Meteor.absoluteUrl() })

            **It's beta.** Broadcasts will, if at all, come unregularly and might contain mistakes. You can [report bugs](#{ Meteor.settings.email.from.emailAddress })
            """

    if subscriptionId?
      text += "\n\n[Unsubscribe](#{ Meteor.absoluteUrl() }_/endSubscription/#{ subscriptionId })"

    return text

  broadcast: ->
    Security.checkRole this, 'admin'

    @unblock()

    console.log "Broadcasting... " + moment().format('LL')

    Subscriptions.find(
      active: true
      confirmed: true
    ).forEach((subscription) ->
      Meteor.call('generateBroadcastForUserAsMarkdown', subscription._id, (error, markdown) ->
        # console.log "For #{subscription.email}:\n#{markdown}\n"

        Meteor.call('wwf.email',
          subject: "we won't forget - #{ moment().format('wo') } broadcast of #{ moment().format('YYYY') }"
          text: markdown
          to: subscription.email
          html: "<html><body>" + marked(markdown) + "</body></html"
        )
      )
    )
)

#todo: cronjob