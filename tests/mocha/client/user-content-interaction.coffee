should = chai.should()
expect = chai.expect

_createUserAndLogIn = (done, groups) ->
  groups ?= []

  Meteor.call('createUserInGroups', groups,
    TestUtility.AsyncForward done, (createdUser) ->
      user = createdUser

      Meteor.loginWithPassword(id: user._id, user.password,
        TestUtility.Async done, ->
          expect(Meteor.userId()).to.exist
          console.log "User logged in: " + user._id
      )
  )

if MochaWeb?
  MochaWeb.testOnly ->
    describe 'Topics', ->
      afterEach (done) ->
        Meteor.logout -> done()

      describe '[not logged in]', ->
  #      before (done) ->
  #        Meteor.call 'clear', TestUtility.Async(done)

        it "should not allow topic creation", (done) ->
          Meteor.call(share.METHODS.CREATE_TOPIC,
            Topics._Testing.GenerateData(),
            TestUtility.AsyncErrors.Expect403(done)
          )
          return

        it "prohibit topic suggestion", (done) ->
          topic = Topics._Testing.GenerateSuggestion()

          Meteor.call(share.METHODS.SUGGEST_TOPIC,
            topic,
            TestUtility.AsyncErrors.Expect403(done)
          )


      describe '[logged in (regular)]', ->
        user = null

        beforeEach (done) ->
          console.log 'creating user'
          # Meteor.call 'clear', TestUtility.AsyncForward done, ->
          _createUserAndLogIn(done)


        it "should not allow topic creation", (done) ->
          Meteor.call(share.METHODS.CREATE_TOPIC,
            Topics._Testing.GenerateData(),
            TestUtility.AsyncErrors.Expect403(done)
          )

        it "suggest topic", (done) ->
          topic = Topics._Testing.GenerateSuggestion()

          expect(Meteor.userId()).to.exist
          console.log "I am #{ Meteor.userId() }"

          Meteor.call(share.METHODS.SUGGEST_TOPIC,
            topic,
            TestUtility.Async(done, (result) ->
              Meteor.methods('searchInMailProxy',
                $contains: subject: topic.title,
                TestUtility.Async done, (result) ->
                  result.count().should.equal(1)
              )
            )
          )


      describe '[logged in (curator)]', ->
        user = null

        beforeEach (done) ->
          #Meteor.call 'clear', TestUtility.AsyncClassic done, ->
          _createUserAndLogIn(done, ['curator'])

        it 'should create topic', (done) ->
          topic = Topics._Testing.GenerateData()
          Meteor.call(share.METHODS.CREATE_TOPIC,
            topic,
            TestUtility.Async done, (result) ->
              should.exist(result)

              # result.should.include.keys topic
              result.name.should.equal topic.name
              moment(result.dateStarted).toDate().getTime().should.equal topic.dateStarted.getTime()
          )