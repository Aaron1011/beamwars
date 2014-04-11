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

define(['position', 'player', 'synchronizedtime', 'singleplayerlistener', 'walls', 'point', '../lib/underscore'], (Position, Player, SynchronizedTime, SinglePlayerListener, walls, Point, _) ->

  class Game

    @WIDTH:  800
    @HEIGHT:  800

    @VELOCITY = 100

    @use_collisions = true

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

      @players = {0: @player0, 1: @player1, 2: @player2, 3: @player3}

      if @browser
        @collide_listeners.push(new SinglePlayerListener(this))


      @old_time = SynchronizedTime.getTime()


    getPositions: ->
      p.lastPos() for k, p of @players

    killPlayer: (player, point) ->
      if @players.indexOf(player) != -1
        @killedPlayers.push(@players.splice(@players.indexOf(player), 1))


    getCurrentLines: ->
      p.currentLine() for k, p of @players

    move_players: (elapsed_time, new_time) ->
      segments = []
      for i, player in @players
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
      oldTime = true # If time was passed
      if not time? # If time is null
        time = SynchronizedTime.getTime()
        oldTime = false
      lastpos = @players[player_index].currentPosition(time)
      player = @players[player_index]
      return unless player.alive
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
      player.lastPoint = player.currentPosition(newTime)
      @walls.update_wall(player_index, segment)
      @emit_collisions([segment])

      for listener in @canvas_listeners
        listener.notify('Turn', [player_index, player.lastPos(), player.currentPosition(time)])


    emit_collisions: (segments) ->
      dead = []
      if Game.use_collisions
        for segment in segments
          collisions = @walls.detect_collisions(segment)
          for collision in collisions
            for listener in @collide_listeners
              #console.log "Collision: ", collision
              if @doNotify[collision[0].player.id]
                if collision != false
                  collision[0].player.alive = false
                  dead.push(collision[0].player)
                  listener.notify('Collide', [collision[0].player.id, collision[1].player.id, collision[2]]) if collision != false

      @walls.removePlayer(p) for p in dead
        #for p in @killedPlayers
        #  @players.splice(p, 1)


        #console.log "Collisions: ", collisions


    timer_tick: (svgOutputFile = null) ->
      new_time = SynchronizedTime.getTime()

      fn(this) for fn in @after_fns
      @after_fns = []



#segments = @move_players(elapsed_time, new_time)

      players = (p for i, p of @players when p.alive == true)
      segments = []

      for player in players
        segment = new walls.WallSegment(player.lastPoint, player.currentPosition(), player)
        segments.push(segment)
        #picture.addSegment(segment, true) if svgOutputFile?
        
        @walls.update_wall(player.id, segment)

        player.lastPoint = player.currentPosition()
      @emit_collisions(segments)

      positions = {}
      positions[p.id] = p.currentPosition() for p in players

      for listener in @canvas_listeners
        listener.notify('Tick', positions)

            #@handle_input(new_time)

            #@old_time = new_time
      @output(svgOutputFile) if svgOutputFile?

    handleCollisionMessage: (collider, collidee, point) ->
      for listener in @collide_listeners
        listener.notify(collider, collidee, point)

    output: (svgOutputFile) ->
      picture = @canvas_listeners[0].output()
      fs = require('fs')
      fs.writeFileSync(svgOutputFile, picture)


    addListener: (listener) ->
      @collide_listeners.push(listener)

    addCanvasListener: (listener) ->
      @canvas_listeners.push(listener)

    runAfterTick: (fn) ->
      @after_fns.push(fn)

    registerCollisionInterest: (playerNumber) ->
      @doNotify[playerNumber] = true

  Game
)
