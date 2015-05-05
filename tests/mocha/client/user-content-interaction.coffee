should = chai.should()
expect = chai.expect

if MochaWeb?
  MochaWeb.testOnly ->
    describe 'Topics / not logged in', ->
      before (done) ->
        Meteor.call 'clear', TestUtility.Async(done)

      it "should not allow topic creation", (done) ->
        Meteor.call(share.METHODS.CREATE_TOPIC,
          Topics._Testing.GenerateData(),
          TestUtility.AsyncClassic done, (error, result) ->
            should.exist(error)
            should.not.exist(result)
            error.error.should.equal 403
            done()
        )
        return

      it "suggest topic", (done) ->
        topic = Topics._Testing.GenerateSuggestion()

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


    describe 'Topics / logged in [curator]', ->
      user = null

      before (done) ->
        Meteor.call 'clear', (error) ->
          if error?
            done(error)
            return

          Meteor.call('createUserInGroups', ['curator'], (error, createdUser) ->
            if error?
              done(error)
              return

            user = createdUser

            console.log user

            Meteor.loginWithPassword(id: user._id, user.password,
              (error) ->
                if error?
                  done(error)
                  return

                done()
            )
          )

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

    describe 'Topics / logged in [regular user]', ->
      user = null

      before (done) ->
        Meteor.call 'clear', (error) ->
          if error?
            done(error)
            return

          Meteor.call('createUserInGroups', [], (error, createdUser) ->
            if error?
              done(error)
              return

            user = createdUser

            console.log user

            Meteor.loginWithPassword(id: user._id, user.password,
              (error) ->
                if error?
                  done(error)
                  return

                done()
            )
          )

      it "should not allow topic creation", (done) ->
        topic = Topics._Testing.GenerateData()
        Meteor.call(share.METHODS.CREATE_TOPIC,
          topic,
          TestUtility.AsyncClassic done, (error, result) ->
            should.exist(error)
            should.not.exist(result)
            error.error.should.equal 403
            done()
        )