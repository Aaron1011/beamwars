class Position

  constructor: (pos, @direction, @time) ->
    @pos = new paper.Point(pos)

window.Position = Position
