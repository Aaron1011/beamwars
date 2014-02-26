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

define(['position', 'player', 'synchronizedtime', 'singleplayerlistener', 'walls', 'point'], (Position, Player, SynchronizedTime, SinglePlayerListener, walls, Point) ->

  class Game

    @WIDTH:  800
    @HEIGHT:  800

    @VELOCITY = 100

    @use_collisions = false

    constructor: () ->
      @players = []
      @killedPlayers = []
      @collide_listeners = []
      @canvas_listeners = []
      @browser = false
      @after_fns = []
      @walls = new walls.Walls(this)


    start: ->
      @player0 = new Player("Player0", new Position([Game.WIDTH/2, 0], Point.SOUTH, 0), this)
      @player1 = new Player("Player1", new Position([Game.WIDTH, Game.HEIGHT/2], Point.WEST, 0),  this)
      @player2 = new Player("Player2", new Position([Game.WIDTH/2, Game.HEIGHT], Point.NORTH, 0),  this)
      @player3 = new Player("Player3", new Position([0, Game.HEIGHT/2], Point.EAST, 0),  this)

      @players = [@player0, @player1, @player2, @player3]

      if @browser
        @collide_listeners.push(new SinglePlayerListener(this))


      @old_time = SynchronizedTime.getTime()

    keyDown: (player, key, coord) ->
      pos = player.lastPos()
      pos.pos = coord
      switch key
        when 37
          pos.direction = Point.WEST
        when 38
          pos.direction = Point.NORTH
        when 39
          pos.direction = Point.EAST
        when 40
          pos.direction = Point.SOUTH

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



    handle_input: (player, key, time=SynchronizedTime.getTime()) ->
      lastpos = @players[player].currentPosition(time)
      player = @players[player]
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


    timer_tick: ->
      new_time = SynchronizedTime.getTime()

      fn(this) for fn in @after_fns
      @after_fns = []

      #segments = @move_players(elapsed_time, new_time)

      if Game.use_collisions
        for player in @players
          collisions = @walls.add_point(player, player.currentPosition())
          for collision in collisions
            for listener in @collide_listeners
              listener.notify(collision[0].player, collision[1].player, collision[2]) if collision != false
          console.log "Collisions: ", collisions

      for listener in @canvas_listeners
        listener.notify('Tick', (p.currentPosition() for p in @players))

      #@handle_input(new_time)

      @old_time = new_time

    addListener: (listener) ->
      @collide_listeners.push(listener)

    addCanvasListener: (listener) ->
      @canvas_listeners.push(listener)

    runAfterTick: (fn) ->
      @after_fns.push(fn)

  Game
)
