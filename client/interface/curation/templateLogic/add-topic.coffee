Template.add_topic.events(
  'submit .create-topic': (event, template) ->
    event.preventDefault()

    Meteor.call('createTopic',
      name: template.find('.topic-title').value
      dateStarted: moment(template.find('.topic-start_date').value, "YYYY-MM-DD").toDate()
    , (error) ->
      console.dir error
    )
)

Template.add_topic.rendered = ->
  $('.datepicker').each((index, element) ->
    new Pikaday(
      field: element
    )
  )