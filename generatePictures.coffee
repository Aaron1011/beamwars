requirejs = require('requirejs')

requirejs.config({
  nodeRequire: require,
  shim: {
    'socketio': {
      exports: 'io'
    }
    'underscore': {
      exports: 'underscore'
    }
  }
  paths: {
	  #fabric: [
      #'lib/fabric']
    #jquery: 'lib/jquery'

    socketio: '/socket.io/socket.io',
    underscore: 'lib/underscore'
  }
})

requirejs ['game', 'synchronizedtime', 'game_canvas'], (Game, SynchronizedTime, GameCanvas) ->
  fs = require('fs')
  config = JSON.parse(fs.readFileSync(process.argv[2]))
  console.log "Config: ", config
  for player, moves of config
    i = 0
    game = new Game()
    game.addCanvasListener(new GameCanvas())
    game.start()

    console.log "Player:", player, "Moves:", moves
    for move in moves
      if not (move instanceof Array)
        SynchronizedTime.setTimeForTesting(move)
        console.log "Number!"
      else
        if move[1] instanceof Array
          SynchronizedTime.setTimeForTesting(move[0])
          move = move[1]
        console.log "Move: ", move
        game.handle_input((move)...)
      game.timer_tick(player + '_' + i + '.svg')
      i += 1
