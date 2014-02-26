requirejs.config({
  paths: {
    fabric: [
      'lib/fabric']
  }
})

require ['game_canvas', 'game', 'synchronizedtime', 'position', 'lib/fabric', 'lib/jquery'], (Canvas, Game, SynchronizedTime, Position) -> # Fabric is deliberately not set as an argument

  console.log "Fabric: ", fabric
  console.log "Position: ", new Position([1,2], 0, 5)
  console.log "Canvas: ", $("#canvas")

  window.game_canvas = new Canvas('canvas')
  window.game = new Game()
  SynchronizedTime.setTimeForTesting(0)
  game.start()

  game.addCanvasListener(game_canvas)
  
  $("#change").click(->
    SynchronizedTime.setTimeForTesting(parseFloat($("#time").val()))
    game.timer_tick()
    #game_canvas.timerTick([{'x': 400, 'y': 100}, {x: 700, y: 400}, {x: 400, y: 700}, {x: 100, y: 400}])
  )

  $("#turn").click(->
    console.log "Click!"
    game.handle_input(parseInt($("#player").val()), parseInt($("#direction").val()), parseFloat($("#turn_time").val()))
    game.timer_tick()
  )

  $("#collide").click(->
    console.log "Collide!"
    game_canvas.registerCollision(parseInt($("#collide_player").val()))
  )
  ###
  setInterval((->
    SynchronizedTime.time += 1/10
    game.timer_tick()
    ),
    100
  )
  ###

