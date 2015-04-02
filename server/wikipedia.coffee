methods = {}

methods[share.METHODS.WIKIPEDIA_SUMMARY] = (wikipediaPageId) -> Wikipedia.getSummaryForPageId wikipediaPageId
methods[share.METHODS.WIKIPEDIA_SEARCH] = (query) -> Wikipedia.search query

Meteor.methods(methods)