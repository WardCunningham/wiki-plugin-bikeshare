
escape = (text)->
  text
    .replace /&/g, '&amp;'
    .replace /</g, '&lt;'
    .replace />/g, '&gt;'

parse = (text) ->
  config = {lines: []}
  for line in text.split /\n/
    config.lines.push escape line
  config

emit = ($item, item) ->
  config = parse item.text
  $item.append """
    <p style="background-color:#eee;padding:15px;">
      #{config.lines.join '<br>'}
    </p>
  """

bind = ($item, item) ->
  $item.dblclick -> wiki.textEditor $item, item

window.plugins.bikeshare = {emit, bind} if window?
module.exports = {parse} if module?

