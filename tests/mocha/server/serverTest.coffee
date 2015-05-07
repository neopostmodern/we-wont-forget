Meteor.startup ->
  Meteor.call 'clear'

#if MochaWeb?
#  MochaWeb.testOnly ->
#    describe 'a group of tests', ->
#      it 'should respect equality', ->
#        chai.assert.equal 5, 5
#      return
#    return
#  return