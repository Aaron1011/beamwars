define ['game', 'synchronizedtime'], (Game, SynchronizedTime) ->
  game = new Game()
  game.start()
  setInterval((->
    SynchronizedTime.time += 1
    game.timer_tick()
    ),
    1000
  )

