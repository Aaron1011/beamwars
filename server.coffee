requirejs = require("requirejs")

requirejs.config({
    nodeRequire: require
#    paths: {
#      fabric: [
#        'lib/fabric']
#    }
})

requirejs ['game', 'synchronizedtime'], (Game, SynchronizedTime) ->

  app = require("express")()
  server = require('http').createServer(app)
  io = require('socket.io').listen(server)

#  game = new Game()
 # SynchronizedTime.setTimeForTesting(0)
 # game.start()

  server.listen(8000)

  app.get '/', (req, res) ->
    res.sendfile(__dirname + '/index.html')


  io.sockets.on 'connection', (socket) ->
    socket.on 'time', (data) ->
      console.log "Time: ", data
      SynchronizedTime.setTimeForTesting(data)
      console.log "New time: ", SynchronizedTime.getTime()

