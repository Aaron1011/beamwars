requirejs = require('requirejs')

requirejs.config({
  baseUrl: './src'
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
    underscore: '../lib/underscore'
  }
})

requirejs ['game', 'synchronizedtime', 'game_canvas'], (Game, SynchronizedTime, GameCanvas) ->
  fs = require('fs')
  config = JSON.parse(fs.readFileSync(process.argv[2]))

  table = ''
  tableHeader = '<table><tr><td></td>'

  moves = config[Object.keys(config)[0]]
  for move in moves
    if not (move instanceof Array)
      tableHeader += '<td>' + 'Time ' + move + '</td>'
  tableHeader += '</tr>'


  for player, moves of config
    i = 0
    table += '<tr>' + '<td>' + player + ': ' + '</td>'
    game = new Game()
    game.addCanvasListener(new GameCanvas())
    game.start()

    for move in moves
      if not (move instanceof Array)
        SynchronizedTime.setTimeForTesting(move)
        filename = player + '_' + i + '.svg'
        game.timer_tick(filename)
        table += '<td>' + '<img src=\"' + './' + filename + '\"</img>' + '</td>'
      else
        if move[1] instanceof Array
          SynchronizedTime.setTimeForTesting(move[0])
          move = move[1]
        game.handle_input((move)...)
        game.timer_tick()
      i += 1
    table += '</tr>'
  table += '</table>'
  tableHeader += table

  console.log tableHeader
