# build time tests for bikeshare plugin
# see http://mochajs.org/

bikeshare = require '../client/bikeshare'
expect = require 'expect.js'

describe 'bikeshare plugin', ->

  describe 'parse text', ->

    it 'can pass text', ->
      config = bikeshare.parse 'hello world'
      expect(config.lines).to.eql ['hello world']

    it 'can escape text', ->
      config = bikeshare.parse 'hello <thing>'
      expect(config.lines).to.eql ['hello &lt;thing&gt;']

    it 'can break lines', ->
      config = bikeshare.parse 'hello\nworld'
      expect(config.lines).to.eql ['hello', 'world']

  describe 'parse gbfs links', ->

    it 'can find station link', ->
      config = bikeshare.parse 'STATION https://gbfs.citibikenyc.com/gbfs/en/station_information.json'
      expect(config.station).to.be 'https://gbfs.citibikenyc.com/gbfs/en/station_information.json'
