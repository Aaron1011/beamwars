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

requirejs ['game', 'synchronizedtime', 'gamepicture'], (Game, SynchronizedTime, GamePicture) ->
  fs = require('fs')
  game = new Game()
  config = JSON.parse(fs.readFileSync(process.argv[2]))
  game.start()
  i = 0
  console.log "Config: ", config
  for player, moves of config
    console.log "Player:", player, "Moves:", moves
    for move in moves
      if not (move instanceof Array)
        SynchronizedTime.setTimeForTesting(move)
        console.log "Number!"
      else
        SynchronizedTime.setTimeForTesting(move[0])
        console.log "Move: ", move
        game.handle_input(move...)
        game.timer_tick(i + '.svg')
      i += 1
