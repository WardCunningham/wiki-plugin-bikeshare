
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
    else if m = line.match /^NEARBY/
      config.nearby = true
    else
      config.lines.push escape line
  config

lineup = ($item) ->
  return [{lat: 51.5, lon: 0.0, label: 'North Greenwich'}] unless wiki?
  markers = []
  candidates = $(".item:lt(#{$('.item').index($item)})")
  if (who = candidates.filter ".marker-source").size()
    markers = markers.concat div.markerData() for div in who
  markers

nearby = (stops, stations) ->
  keeps = {}
  for stop in stops
    quads = [[],[],[],[]]
    for s in stations
      s.weblink ||= stop.weblink
      quad = (if s.lat > stop.lat then 2 else 0) + (if s.lon > stop.lon then 1 else 0)
      dist = Math.abs(s.lat - stop.lat) + Math.abs(s.lon - stop.lon)
      quads[quad].push [dist, s]
    for q in quads
      rank = q.sort (a,b) -> a[0] - b[0]
      for r in rank[0..0]
        keeps[r[1].name] = r[1]
  (v for k, v of keeps)


emit = ($item, item) ->
  config = parse item.text
  $item.append """
    <p style="background-color:#eee;padding:15px; text-align:center">
      #{config.lines.join '<br>'}
    </p>
  """

  if config.station
    qualification = ''
    $.getJSON config.station, (result) ->
      config.stations = if config.nearby
        markers = lineup $item
        if markers.length
          qualification = 'nearby'
          nearby markers, result.data.stations
        else
          result.data.stations
      else 
        result.data.stations
      $item.find('.station').empty().append "#{config.stations.length} stations #{qualification}"

  $item.addClass 'marker-source'
  $item.get(0).markerData = ->
    if config.stations
      ({lat:s.lat, lon:s.lon, label:s.name, weblink: s.weblink} for s in config.stations)
    else
      []


bind = ($item, item) ->
  $item.dblclick -> wiki.textEditor $item, item

window.plugins.bikeshare = {emit, bind} if window?
module.exports = {parse} if module?

