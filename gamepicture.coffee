
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
        console.log "Segment: ", segment
        line = new fabric.Polyline([segment.startpoint, segment.endpoint], {fill: 'none', stroke: 5, strokeColor: 'blue'}, true)
        line.stroke = 'red' if newLine
        @picture += line.toSVG()
        console.log "Segment!"

    output: (file) ->
      console.log "Output!"
      picture = '<svg xmlns="http://www.w3.org/2000/svg" width="800" height="800">' + @picture + '</svg>'
      fs = require('fs')
      fs.writeFileSync(file, picture)
      console.log "Output!"

  GamePicture
)

