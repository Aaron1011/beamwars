class Position

  constructor: (@pos, @direction, @time) ->
    @x = pos[0]
    @y = pos[1]

window.Position = Position
