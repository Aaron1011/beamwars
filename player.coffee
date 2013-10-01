class Player

  constructor: (pos) ->
    @positions = []
    @positions.push(pos)
    @current_line = []

  lastPos: ->
    @positions[@positions.length - 1]

  addToLine: (pos) ->
    @current_line.push(pos)

window.Player = Player
