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
  
  $("#change").click(->
    game_canvas.timerTick([{'x': 400, 'y': 100}, {x: 700, y: 400}, {x: 400, y: 700}, {x: 100, y: 400}])
  )

  ###
  setInterval((->
    SynchronizedTime.time += 1/10
    game.timer_tick()
    ),
    100
  )
  ###

