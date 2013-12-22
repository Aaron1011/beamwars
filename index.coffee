requirejs.config({
  paths: {
    fabric: [
      'lib/fabric']
  }
})

define ['game', 'synchronizedtime', 'position', 'lib/fabric', 'lib/jquery'], (Game, SynchronizedTime, Position) -> # Fabric is deliberately not set as an argument

  canvas = $("#canvas")
  canvas.width = document.body.clientWidth
  canvas.height = document.body.clientHeight

  console.log "Fabric: ", fabric
  console.log "Position: ", new Position([1,2], 0, 5)
  canvas = new fabric.Canvas('canvas', {renderOnAddRemove: false})
  window.canvas = canvas

  game = new Game(canvas)
  game.browser = true
  $(document).keydown (e) -> game.keyDown(e.which)

  game.start()
  setInterval((->
    SynchronizedTime.time += 1/10
    game.timer_tick()
    ),
    100
  )

