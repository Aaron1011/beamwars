requirejs = require('requirejs')

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

requirejs ['game', 'synchronizedtime', 'gamepicture'], (Game, SynchronizedTime, GamePicture) ->
	config = JSON.parse(fs.readSync(process.argv[2]))
	game.start()
	i = 0
	for player, moves in config
		picture = new GamePicture(Game.WIDTH, Game.HEIGHT)
		for move in moves
			if not move instanceof Array
				SynchronizedTime.setTimeForTesting(move)
			else
				SynchronizedTime.setTimeForTesting(move[0])
				game.handle_input(move[1]...)
			game.timer_tick(i + '.svg')
		i += 1
