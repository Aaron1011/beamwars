requirejs = require("requirejs")
express = require("express")

requirejs.config({
    nodeRequire: require
    shim: {
      'socketio': {
        exports: 'io'
      }
      'underscore': {
        exports: 'underscore'
      }
    }
    paths: {
        socketio: '../socket.io/socket.io',
        underscore: 'lib/underscore'
    }
#    paths: {
#      fabric: [
#        'lib/fabric']
#    }
})



requirejs ['game', 'synchronizedtime', 'http'], (Game, SynchronizedTime, http) ->

  app = express()

  ids = []

  app.use express.static(__dirname)

  server = http.createServer(app)
  io = require('socket.io').listen(server)

  game = new Game()
  SynchronizedTime.setTimeForTesting(0)
  game.start()

  server.listen(8000)

  io.sockets.on 'connection', (socket) ->
    #socket.set 'id', id, ->
    #  socket.emit 'id', id

    socket.on 'time', (time) ->
      console.log "Time: ", time
      SynchronizedTime.setTimeForTesting(time)
      console.log "New time: ", SynchronizedTime.getTime()
      socket.broadcast.emit('time', time)
    socket.on 'turn', (data) ->
      console.log "Turn: ", data
      game.handle_input(data.player, data.direction, data.time)
      socket.broadcast.emit('turn', data)
