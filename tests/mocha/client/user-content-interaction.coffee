should = chai.should()
expect = chai.expect

if MochaWeb?
  MochaWeb.testOnly ->
    describe 'Topics / not logged in', ->
      before (done) ->
        Meteor.call 'clear', TestUtility.Async(done)

      it "should not allow topic creation", (done) ->
        Meteor.call('createTopic',
          {
            name: 'asd'
            dateStarted: moment("2013-09-20", "YYYY-MM-DD").toDate()
          },
          TestUtility.AsyncClassic done, (error, result) ->
            should.exist(error)
            should.not.exist(result)
            error.error.should.equal 403
            done()
        )
        return

    describe 'Topics / logged in', ->
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
        topic = TestUtility.Topic.GenerateData()
        Meteor.call('createTopic',
          topic,
          TestUtility.Async done, (result) ->
            should.exist(result)

            # result.should.include.keys topic
            result.name.should.equal topic.name
            moment(result.dateStarted).toDate().getTime().should.equal topic.dateStarted.getTime()
          )