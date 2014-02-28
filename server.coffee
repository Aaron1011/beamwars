requirejs = require("requirejs")
express = require("express")

requirejs.config({
    nodeRequire: require
    shim: {
      'socketio': {
        exports: 'io'
      }
    }
    paths: {
        socketio: '../socket.io/socket.io',
    }
#    paths: {
#      fabric: [
#        'lib/fabric']
#    }
})

requirejs ['game', 'synchronizedtime', 'http'], (Game, SynchronizedTime, http) ->

  app = express()

  app.use express.static(__dirname)

  server = http.createServer(app)
  io = require('socket.io').listen(server)

  game = new Game()
  SynchronizedTime.setTimeForTesting(0)
  game.start()

  server.listen(8000)



  io.sockets.on 'connection', (socket) ->
    socket.on 'time', (data) ->
      console.log "Time: ", data
      SynchronizedTime.setTimeForTesting(data)
      console.log "New time: ", SynchronizedTime.getTime()

