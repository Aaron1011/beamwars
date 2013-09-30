class Player

  constructor: (pos) ->
    @positions = []
    @positions.push(pos)
    @current_line = []

  lastPos: ->
    @positions[@positions.length - 1]

window.Player = Player
