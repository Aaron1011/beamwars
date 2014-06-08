requirejs = require("requirejs")
express = require("express")
http = require("http")

requirejs.config({
    baseUrl: './src',
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


ids = []

getId = ->
  id = 0
  while (id in ids)
    id += 1
  return id



requirejs ['game', 'synchronizedtime'], (Game, SynchronizedTime) ->

  app = express()


  app.use express.static(__dirname)

  server = http.createServer(app)
  io = require('socket.io').listen(server)

  game = new Game()
  SynchronizedTime.setTimeForTesting(0)
  game.start()

  server.listen(8000)

  io.sockets.on 'connection', (socket) ->
    id = getId()
    socket.emit 'id', id
    socket.set('id', id)
    ids.push(id)

    socket.on 'time', (time) ->
      console.log "Time: ", time
      SynchronizedTime.setTimeForTesting(time)
      console.log "New time: ", SynchronizedTime.getTime()
      socket.broadcast.emit('time', time)
    socket.on 'turn', (data) ->
      console.log "Turn: ", data
      game.handle_input(data.player, data.direction, data.time)
      socket.broadcast.emit('turn', data)
    socket.on 'start', ->
      socket.emit('start')
      socket.broadcast.emit('start')
      setInterval((->
        SynchronizedTime.time += 1/60
        game.timer_tick()
      ),
      (1/60) * 1000)

    socket.on 'disconnect', ->
      socket.get('id', (err, id) ->
        ids.splice(ids.indexOf(id), 1))
