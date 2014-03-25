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

  currentPlayer = 0



  console.log "Fabric: ", fabric
  console.log "Position: ", new Position([1,2], 0, 5)
  console.log "Canvas: ", $("#canvas")

  window.game_canvas = new Canvas('canvas')
  window.game = new Game()
  SynchronizedTime.setTimeForTesting(0)
  game.start()

  game.addCanvasListener(game_canvas)
  
  $("#change").click(->
    time = parseFloat($("#time").val())
    SynchronizedTime.setTimeForTesting(time)
    game.timer_tick()
    socket.emit('time', time) if $("#server_time").is(':checked')
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

  socket.on 'id', (id) ->
    currentPlayer = id

  socket.on 'turn', (data) ->
    console.log "Turn: ", data
    game.handle_input(data.player, data.direction, data.time)

  socket.on 'time', (time) ->
    console.log "Time: ", time
    SynchronizedTime.setTimeForTesting(time)
    game.timer_tick()
    $("#time").val(time)



  $(document).keydown (e) ->
    console.log "Key!"
    if Game.KEY_WEST <= e.which <= Game.KEY_SOUTH
      console.log "Yup!"
      time = SynchronizedTime.getTime()
      game.handle_input(currentPlayer, e.which, time)
      socket.emit('turn', {player: 0, direction: e.which, time: time})
  
  ###
  setInterval((->
    SynchronizedTime.time += 1/60
    game.timer_tick()
    ),
    (1/60) * 1000
  )
  ###
