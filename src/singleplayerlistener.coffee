define(['listener'], (Listener) ->
  class SinglePlayerListener extends Listener
    notify: (player1, player2, point) ->
     console.log "Collision: #{player1.name} #{player2.name} #{point}"
     @game.runAfterTick((game) -> game.killPlayer(player2, point))


  SinglePlayerListener
)
