# build time tests for bikeshare plugin
# see http://mochajs.org/

bikeshare = require '../client/bikeshare'
expect = require 'expect.js'

describe 'bikeshare plugin', ->

  describe 'expand', ->

    it 'can make itallic', ->
      result = bikeshare.expand 'hello *world*'
      expect(result).to.be 'hello <i>world</i>'
