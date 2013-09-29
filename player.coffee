class Player

  constructor: (pos) ->
    @positions = []
    @positions.push(pos)

  lastPos: ->
    @positions[@positions.length - 1]

window.Player = Player
