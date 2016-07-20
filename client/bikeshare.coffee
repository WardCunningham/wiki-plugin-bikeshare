
escape = (text)->
  text
    .replace /&/g, '&amp;'
    .replace /</g, '&lt;'
    .replace />/g, '&gt;'

parse = (text) ->
  config = {lines: []}
  for line in text.split /\n/
    if m = line.match /^STATION *(.*)/
      config.station = m[1]
      config.lines.push "<span class=station><i>waiting for stations</i></span>"
    else
      config.lines.push escape line
  config

emit = ($item, item) ->
  config = parse item.text
  $item.append """
    <p style="background-color:#eee;padding:15px;">
      #{config.lines.join '<br>'}
    </p>
  """

  if config.station
    $.getJSON config.station, (result) ->
      config.stations = result.data.stations
      $item.find('.station').empty().append "#{config.stations.length} stations"
      console.log 'stations', config.stations

  $item.addClass 'marker-source'
  $item.get(0).markerData = ->
    if config.stations
      ({lat:s.lat, lon:s.lon, label:s.name} for s in config.stations)
    else
      []


bind = ($item, item) ->
  $item.dblclick -> wiki.textEditor $item, item

window.plugins.bikeshare = {emit, bind} if window?
module.exports = {parse} if module?

