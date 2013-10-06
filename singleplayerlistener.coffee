define(['listener'], (Listener) ->
  class SinglePlayerListener extends Listener
    notify: (player1, player2, point) ->
     console.log "Collision: #{player1} #{player2} #{point}"
     @game.killPlayer(player2, point)


  SinglePlayerListener
)
