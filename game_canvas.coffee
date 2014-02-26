define ['fabric', 'lib/underscore'], (fabric) ->

  fabric = fabric.fabric if fabric.fabric?

  class GameCanvas

    constructor: (canvasId) ->
      @canvas = new fabric.Canvas(canvasId)
      options = {strokeWidth: 5, fill: 'none'}
      @lines = [new fabric.Polyline([{'x': @canvas.getWidth() / 2, 'y': 0}], _.extend(options, {'stroke': 'green'}), true),
        new fabric.Polyline([{'x': @canvas.getWidth(), y: @canvas.getHeight() / 2}], _.extend(options, {'stroke': 'blue'}), true),
        new fabric.Polyline([{'x': @canvas.getWidth() / 2, y: @canvas.getHeight()}], _.extend(options, {'stroke': 'red'}), true),
        new fabric.Polyline([{'x': 0, y: @canvas.getHeight() / 2}], _.extend(options, {'stroke': 'purple'}), true)]

      for line in @lines
        line.points.push(line.points[0])
        @canvas.add(line)

    timerTick: (positions) ->
      for line, i in @lines
        line.points.pop()
        line.points.push(positions[i])
      @canvas.renderAll()
     
    turn: (playerIndex, turnPos, currentPos) ->
      line = @lines[playerIndex]
      line.points.pop()
      line.points.push(turnPos)
      line.points.push(currentPos)

    getWidth: ->
      @canvas.getWidth()
    
    getHeight: ->
      @canvas.getHeight()

    notify: (eventType, data) ->
      if eventType == 'Tick'
        @timerTick(data)

  GameCanvas
