requirejs.config({
  shim: {
    'socketio': {
      exports: 'io'
    }
    'underscore': {
      exports: 'underscore'
    }
  }
  paths: {
    fabric: [
      'lib/fabric']
    jquery: 'lib/jquery'

    socketio: '/socket.io/socket.io',
    underscore: 'lib/underscore'
  }
})

require ['lib/domReady!', 'game_canvas', 'game', 'synchronizedtime', 'position', 'socketio', 'jquery', 'lib/fabric'], (doc, Canvas, Game, SynchronizedTime, Position, io, $) -> # Fabric is deliberately not set as an argument
  socket = io.connect('http://localhost')



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

    player = parseInt($("#player").val())
    direction = parseInt($("#direction").val())
    time = parseFloat($("#turn_time").val())

    game.handle_input(player, direction, time)
    game.timer_tick()
    socket.emit('turn', {player: player, direction: direction, time: time}) if $("#server_turn").is(':checked')
  )

  $("#collide").click(->
    console.log "Collide!"
    game_canvas.registerCollision(parseInt($("#collide_player").val()))
  )

  socket.on 'turn', (data) ->
    console.log "Turn: ", data
    game.handle_input(data.player, data.direction, data.time)


  ###
  setInterval((->
    SynchronizedTime.time += 1/10
    game.timer_tick()
    ),
    100
  )
  ###
