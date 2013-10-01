define([], ->

  class Player

    constructor: (pos) ->
      @positions = []
      @positions.push(pos)
      @current_line = []

    lastPos: ->
      @positions[@positions.length - 1]

    currentLine: ->
      @current_line.slice() # Copy array

    addToLine: (pos) ->
      @current_line.push(pos)

  Player
)
