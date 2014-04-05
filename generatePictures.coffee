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
  console.log "Config: ", config

  table = ''
  tableHeader = '<table><tr><td></td>'

  moves = config[Object.keys(config)[0]]
  for move in moves
    if move instanceof Array
      time = move[0]
    else
      time = move
    tableHeader += '<td>' + 'Time ' + time + '</td>'
  tableHeader += '</tr>'


  for player, moves of config
    i = 0
    table += '<tr>' + '<td>' + player + ': ' + '</td>'
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
      filename = player + '_' + i + '.svg'
      game.timer_tick(filename)
      table += '<td>' + '<img src=\"' + './img/' + filename + '\"</img>' + '</td>'
      i += 1
    table += '</tr>'
  table += '</table>'
  tableHeader += table

  console.log tableHeader
