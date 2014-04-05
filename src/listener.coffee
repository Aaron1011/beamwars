define([], ->
  class Listener
    constructor: (@game) ->

    notify: (player1, player2, point) ->
      console.log "Listener#notify with #{player1}, #{player2}, #{p}"

  Listener
)
