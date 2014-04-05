#    BeamWars - A multiplayer in-browser remake of the Mac game of the same name
#    Copyright (C) 2013  Aaron Hill
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see http://www.gnu.org/licenses/.

define(['position', 'player', 'synchronizedtime', 'singleplayerlistener', 'walls', 'point', 'gamepicture'], (Position, Player, SynchronizedTime, SinglePlayerListener, walls, Point, GamePicture) ->

  class Game

    @WIDTH:  800
    @HEIGHT:  800

    @VELOCITY = 800

    @use_collisions = false

    @KEY_WEST = 37
    @KEY_NORTH = 38
    @KEY_EAST = 39
    @KEY_SOUTH = 40


    constructor: () ->
      @players = []
      @killedPlayers = []
      @collide_listeners = []
      @canvas_listeners = []
      @browser = false
      @after_fns = []
      @walls = new walls.Walls(this)
      @doNotify = {}


    start: ->
      @player0 = new Player("Player0", new Position([Game.WIDTH/2, 0], Point.SOUTH, 0), this, 0)
      @player1 = new Player("Player1", new Position([Game.WIDTH, Game.HEIGHT/2], Point.WEST, 0),  this, 1)
      @player2 = new Player("Player2", new Position([Game.WIDTH/2, Game.HEIGHT], Point.NORTH, 0),  this, 2)
      @player3 = new Player("Player3", new Position([0, Game.HEIGHT/2], Point.EAST, 0),  this, 3)

      @players = [@player0, @player1, @player2, @player3]

      if @browser
        @collide_listeners.push(new SinglePlayerListener(this))


      @old_time = SynchronizedTime.getTime()


    getPositions: ->
      p.lastPos() for p in @players

    killPlayer: (player, point) ->
      if @players.indexOf(player) != -1
        @killedPlayers.push(@players.splice(@players.indexOf(player), 1))


    getCurrentLines: ->
      p.currentLine() for p in @players

    move_players: (elapsed_time, new_time) ->
      segments = []
      for player in @players
        segments.push(@move_player(player, elapsed_time, new_time))
      segments

    move_player: (player, elapsed_time, new_time) ->
      lastpos = player.lastPos() if !lastpos or lastpos.length == 0
      lastpos = lastpos2 if lastpos2?
      if lastpos.direction == Point.WEST
        player.addToLine(new Position([lastpos.x - (Game.VELOCITY * elapsed_time), lastpos.y], Point.WEST, new_time))
      else if lastpos.direction == Point.EAST
        player.addToLine(new Position([lastpos.x + (Game.VELOCITY * elapsed_time), lastpos.y], Point.EAST, new_time))
      else if lastpos.direction == Point.SOUTH
        player.addToLine(new Position([lastpos.x, lastpos.y + (Game.VELOCITY * elapsed_time)], Point.SOUTH, new_time))
      else if lastpos.direction == Point.NORTH
        player.addToLine(new Position([lastpos.x, lastpos.y - (Game.VELOCITY * elapsed_time)], Point.NORTH, new_time))
      @walls.update_wall(@players.indexOf(player), new walls.WallSegment(lastpos, player.currentLinePos(), player))
      return new walls.WallSegment(lastpos, player.currentLinePos(), player)



    handle_input: (player_index, key, time = null) ->
      oldTime = true
      if not time?
        time = SynchronizedTime.getTime()
        oldTime = false
      lastpos = @players[player_index].currentPosition(time)
      player = @players[player_index]
      if player.lastPos().time > time
        throw Error('IllegalTurnException')
      switch key
        when 37
          player.positions.push(new Position([lastpos.x, lastpos.y], Point.WEST, time))
        when 38
          player.positions.push(new Position([lastpos.x, lastpos.y], Point.NORTH, time))
        when 39
          player.positions.push(new Position([lastpos.x, lastpos.y], Point.EAST, time))
        when 40
          player.positions.push(new Position([lastpos.x, lastpos.y], Point.SOUTH, time))

      newTime = time
      if oldTime
        newTime = SynchronizedTime.getTime()
      segment = new walls.WallSegment(lastpos, @players[player_index].currentPosition(newTime), player)
      @walls.update_wall(player_index, segment)
      @emit_collisions(segment)

      for listener in @canvas_listeners
        listener.notify('Turn', [player_index, player.lastPos(), player.currentPosition(time)])


    emit_collisions: (segments) ->
      if Game.use_collisions
        for segment in segments
          collisions = @walls.detect_collisions(segment)
          for collision in collisions
            for listener in @collide_listeners
              console.log "Collision: ", collision
              if @doNotify[collision[0].player]
                listener.notify(collision[0].player, collision[1].player, collision[2]) if collision != false
          console.log "Collisions: ", collisions


    timer_tick: (svgOutputFile = null) ->
      new_time = SynchronizedTime.getTime()

      fn(this) for fn in @after_fns
      @after_fns = []

      #segments = @move_players(elapsed_time, new_time)

      for player in @players
        segment = new walls.WallSegment(player.lastPoint, player.currentPosition(), player)
        #picture.addSegment(segment, true) if svgOutputFile?
        
	#@walls.update_wall(@players.indexOf(player), segment)

        if Game.use_collisions
          collisions = @walls.detect_collisions(segment)
          console.log "Collisions: ", collisions
          for collision in collisions
            for listener in @collide_listeners
              listener.notify(collision[0].player, collision[1].player, collision[2]) if collision != false

      for listener in @canvas_listeners
        listener.notify('Tick', (p.currentPosition() for p in @players))

            #@handle_input(new_time)

            #@old_time = new_time
      console.log "Output: ", svgOutputFile
      @output(svgOutputFile) if svgOutputFile?

    output: (svgOutputFile) ->
      console.log "Output 2!"
      picture = @canvas_listeners[0].output()
      fs = require('fs')
      fs.writeFileSync(svgOutputFile, picture)
      console.log "Output 3!"

 

    addListener: (listener) ->
      @collide_listeners.push(listener)

    addCanvasListener: (listener) ->
      @canvas_listeners.push(listener)

    runAfterTick: (fn) ->
      @after_fns.push(fn)

    registerCollisionInterest: (playerNumber) ->
      @doNotify[@players[playerNumber]] = true

  Game
)
