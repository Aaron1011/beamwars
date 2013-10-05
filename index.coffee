requirejs.config({
  paths: {
    fabric: [
      'lib/fabric']
  }
})

define ['game', 'synchronizedtime', 'position', 'lib/fabric'], (Game, SynchronizedTime, Position) -> # Fabric is deliberately not set as an argument
  console.log "Fabric: ", fabric
  console.log "Position: ", new Position([1,2], 0, 5)
  canvas = new fabric.Canvas('canvas', {renderOnAddRemove: false})
  window.canvas = canvas

  game = new Game(canvas)
  game.browser = true
  game.start()
  setInterval((->
    SynchronizedTime.time += 1
    game.timer_tick()
    ),
    1000
  )

