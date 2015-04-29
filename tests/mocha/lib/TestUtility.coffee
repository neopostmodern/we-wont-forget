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

  GenerateRandomStringFor: (name) -> name + "-" + Math.random() * 1000

  GenerateRandomInteger: (maximum, minimum) ->
    minimum ?= 0
    maximum -= minimum # equalize range
    Math.round(Math.random() * maximum) + minimum

  GenerateRandomColor: (opacity) -> "rgba(#{ @GenerateRandomInteger(255) }, #{ @GenerateRandomInteger(255) }, #{ @GenerateRandomInteger(255) }, #{ opacity })"



  ## generate topics

  Topic:
    GenerateData: ->
      name: TestUtility.GenerateRandomStringFor('topicName')
      dateStarted: moment("2013-09-20", "YYYY-MM-DD").toDate()