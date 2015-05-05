@TestUtility =
  Async: (done, assertions) ->
    (error, result) ->
      try
        if assertions?
          assertions(result)
        done(error)
      catch assertionError
        done(assertionError)

  AsyncClassic: (done, assertions) ->
    (error, result) ->
      try
        assertions(error, result)
      catch assertionError
        done(assertionError)

  ## generate primitives

  GenerateRandomStringFor: (name) -> "#{ name }-#{ Math.round(Math.random() * 1000) }_#{ Math.round(Math.random() * 1000) }_#{ Math.round(Math.random() * 1000) }"

  GenerateRandomEmail: ->
    TestUtility.GenerateRandomStringFor("email") + "@example.com"

  GenerateRandomInteger: (maximum, minimum) ->
    minimum ?= 0
    maximum -= minimum # equalize range
    Math.round(Math.random() * maximum) + minimum

  GenerateRandomColor: (opacity) -> "rgba(#{ @GenerateRandomInteger(255) }, #{ @GenerateRandomInteger(255) }, #{ @GenerateRandomInteger(255) }, #{ opacity })"

  GenerateRandomDate: (options) ->
    YEAR_IN_SECONDS = 31536000

    options ?= {}

    date = moment()

    if options.pastYears? or options.futureYears?
      date.add(TestUtility.GenerateRandomInteger(
        -1 * (options.pastYears ? 0) * YEAR_IN_SECONDS,
        (options.futureYears ? 0) * YEAR_IN_SECONDS
      ))

    return date

  ## generate topics

topics =
  _Testing:
    GenerateData: ->
      name: TestUtility.GenerateRandomStringFor('topicName')
      dateStarted: TestUtility.GenerateRandomDate(pastYears: 100)

    GenerateSuggestion: ->
      title: TestUtility.GenerateRandomStringFor('suggestedTopicName')
      description: TestUtility.GenerateRandomStringFor('suggestedTopicDescription')
      dateStarted: TestUtility.GenerateRandomDate(pastYears: 100)

@Topics = _.extend @Topics ? {}, topics