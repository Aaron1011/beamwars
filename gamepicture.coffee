###
requirejs.config({
  paths: {
    fabric: [
      'lib/fabric']
	}
}
###

define([], () ->
	fabric = require('fabric')
	class GamePicture
		constructor: (@wdith, @height) ->
			@picture = ''

		addSegment: (segments, newLine = false) ->
			for segment in segments
				line = new fabric.PolyLine(segment.startpoint, segment.endpoint)
				line.strokeColor = 'red' if newLine
				@picture += line.toSVG()
	
		output: (file) ->
			picture = '<svg>' + @picture + '</svg>'
			fs = require('fs')
			fs.writeSync(file, picture)
)

