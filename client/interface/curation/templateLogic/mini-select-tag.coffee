Template.mini_select_tag.helpers(
  filteredTags: ->
    filter = {}

    if Session.get('selectTagFilter')?
      filter.name = new RegExp("^.*#{ Session.get 'selectTagFilter' }.*", "i")

    return Tags.find(filter)
)

Template.mini_select_tag.events(
  'keyup .tag-search': (event, template) ->
    Session.set "selectTagFilter", event.currentTarget.value

  'keypress .tag-search': (event, template) ->
    if event.which is 13
      $('.tag-to-add')[0].click()

  'click .tag-to-add': (event, template) ->
    Meteor.call('tag', Session.get(share.SESSION.TOPIC_ID_FOR_MINI_TAG), event.currentTarget.dataset.tagId, (error) ->
      if error?
        alert error
      else
        share.Modal.close()
    )
)