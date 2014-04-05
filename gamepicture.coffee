
requirejs.config({
  paths: {
    fabric: [
      'lib/fabric']
	}
})


define([], () ->
  fabric = require('fabric').fabric
  class GamePicture
    constructor: (@wdith, @height) ->
      @picture = ''

    addSegment: (segments, newLine = false) ->
      for segment in segments
        line = new fabric.Polyline(segment.startpoint, segment.endpoint)
        line.strokeColor = 'red' if newLine
        @picture += line.toSVG()
        console.log "Segment!"

    output: (file) ->
      picture = '<svg>' + @picture + '</svg>'
      fs = require('fs')
      fs.writeSync(file, picture)
      console.log "Output!"

  GamePicture
)

