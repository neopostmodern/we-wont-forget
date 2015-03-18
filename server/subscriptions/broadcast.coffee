Meteor.methods(
  generateBroadcastForUserAsMarkdown: (userId) ->
    Security.checkRole 'admin'

    topics = Topics.QUERY.forUser(userId, limit: 10)
    # tags = Tags.QUERY.forUser(userId)

    topics_text = ["* #{topic.name} *\[#{ topic.tags.map((tag) -> tag.name).join(", ") }]*" for topic in topics.fetch()].join("\n")

    text =  """
            *#{ moment().format('LL') }*

            we won't forget - weekly broadcast
            ==================================

            10 randomly selected topics
            ---------------------------
            #{topics_text}

            See all at [we won't forget](#{ Meteor.absoluteUrl() })
            """

    return text

  broadcast: ->
    Security.checkRole 'admin'

    Subscriptions.select(
      active: 1
      confirmed: 1
    ).forEach((subscription) ->
      Meteor.call('generateBroadcastForUserAsMarkdown', userId, (markdown) ->
        Meteor.call('email',
          subject: "we won't forget - broadcast #{ moment().format('MM/YYYY') }"
          text: markdown
          to: subscription.email
          # todo: markdown to html. node package?
        )
      )
    )
)

#todo: cronjob