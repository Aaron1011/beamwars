class Position

  constructor: (pos, @direction, @time) ->
    @pos = new fabric.Point(pos)

window.Position = Position
