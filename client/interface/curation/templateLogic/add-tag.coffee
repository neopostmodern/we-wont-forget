Template.add_tag.events(
  'submit form.add-tag': (event, template) ->
    event.preventDefault()

    tag =
      name: template.find('.tag-name').value

    Meteor.call(share.METHODS.ADD_TAG, tag, (error) ->
      if error?
        alert error
    )
)