define ['game', 'fabric', 'underscore'], (Game, fabric, _) ->

  fabric = fabric.fabric if fabric.fabric?

  class GameCanvas

    constructor: (canvasId=null) ->
      if canvasId?
        @canvas = new fabric.Canvas(canvasId)
      else
        console.log "Node!"
        @canvas = fabric.createCanvasForNode(Game.WIDTH, Game.HEIGHT)
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

    output: ->
      @canvas.toSVG()

    turn: (playerIndex, turnPos, currentPos) ->
      console.log "Turn!"
      console.log playerIndex
      line = @lines[playerIndex]
      line.points.pop()
      line.points.push(turnPos)
      line.points.push(currentPos)

    _shrinkPath: (playerIndex, length) ->
      total_distance = 0
      for new_point, i in @lines[playerIndex].points
        break if i == @lines[playerIndex].points.length - 1
        distance = Math.abs(new fabric.Point(new_point.x, new_point.y).distanceFrom(@lines[playerIndex].points[i+1]))
        if total_distance + distance >= length
          @_popPoints(playerIndex, i, length - total_distance)
          break
        total_distance += distance

    _popPoints: (playerIndex, pointIndex, distance) ->
      currPoint = @lines[playerIndex].points[pointIndex]
      nextPoint = @lines[playerIndex].points[pointIndex + 1]
      @lines[playerIndex].points = @lines[playerIndex].points.slice(0, pointIndex + 1)
      if currPoint.x == nextPoint.x
        if currPoint.y - nextPoint.y < 0
          newPoint = {x: currPoint.x, y: currPoint.y + distance}
        else
          newPoint = {x: currPoint.x, y: currPoint.y - distance}
      else
        if currPoint.x - nextPoint.x < 0
          newPoint = {x: currPoint.x + distance, y: currPoint.y}
        else
          newPoint = {x: currPoint.x - distance, y: currPoint.y}
      @lines[playerIndex].points.push(newPoint)

    _lineLength: (playerIndex) ->
      length = 0
      point = @lines[playerIndex].points[0]
      for newPoint in @lines[playerIndex].points
        length += Math.abs(new fabric.Point(newPoint.x, newPoint.y).distanceFrom(point))
        point = newPoint
      length

     
    registerCollision: (playerIndex) ->
      fabric.util.animate(startValue: @_lineLength(playerIndex), endValue: 0, onChange: (value) =>
        @_shrinkPath(playerIndex, value)
        @canvas.renderAll()
      )
      

    getWidth: ->
      @canvas.getWidth()
    
    getHeight: ->
      @canvas.getHeight()

    notify: (eventType, data) ->
      switch eventType
        when 'Tick'
          @timerTick(data)
        when 'Turn'
          @turn(data[0], data[1], data[2])

  GameCanvas
