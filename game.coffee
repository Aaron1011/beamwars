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

define(['position', 'player', 'synchronizedtime', 'point'], (Position, Player, SynchronizedTime, Point) ->

  class Game

    @NORTH = 0
    @SOUTH = 1
    @EAST = 2
    @WEST = 3

    @WIDTH:  200
    @HEIGHT:  300

    @VELOCITY = 100

    @use_collisions = true

    constructor: (@canvas) ->
      @players = []
      @listeners = []
      @browser = false


    start: ->
      @player0 = new Player("Player0", new Position([Game.WIDTH/2, 0], Game.SOUTH, 0))
      @player1 = new Player("Player1", new Position([Game.WIDTH, Game.HEIGHT/2], Game.WEST, 0))
      @player2 = new Player("Player2", new Position([Game.WIDTH/2, Game.HEIGHT], Game.NORTH, 0))
      @player3 = new Player("Player3", new Position([0, Game.HEIGHT/2], Game.EAST, 0))

      @players = [@player0, @player1, @player2, @player3]

      if @browser
        @canvas.add(p.current_line) for p in @players


      @old_time = SynchronizedTime.getTime()

    key_down: (player, key, coord) ->

    getPositions: ->
      p.lastPos() for p in @players

    getCurrentLines: ->
      p.currentLine() for p in @players

    handle_collisions: (player) ->
      pos = player.currentLinePos()
      for p in @players
        continue if p.name == player.name
        for pos2 in p.currentLine()
          if pos2.pos.eq(pos.pos)
            listener.notify(player, p, new Point(pos.pos.x, pos.pos.y)) for listener in @listeners

    move_players: (elapsed_time, new_time) ->
      for player in @players
        lastpos = player.currentLinePos() || player.lastPos()
        if lastpos.direction == Game.WEST
          player.addToLine(new Position([lastpos.x - (Game.VELOCITY * elapsed_time), lastpos.y], Game.WEST, new_time))
        else if lastpos.direction == Game.EAST
          player.addToLine(new Position([lastpos.x + (Game.VELOCITY * elapsed_time), lastpos.y], Game.EAST, new_time))
        else if lastpos.direction == Game.SOUTH
          player.addToLine(new Position([lastpos.x, lastpos.y + (Game.VELOCITY * elapsed_time)], Game.SOUTH, new_time))
        else if lastpos.direction == Game.NORTH
          player.addToLine(new Position([lastpos.x, lastpos.y - (Game.VELOCITY * elapsed_time)], Game.NORTH, new_time))

    render_game: ->
      @canvas.renderAll()


    timer_tick: ->
      new_time = SynchronizedTime.getTime()
      elapsed_time = new_time - @old_time

      @move_players(elapsed_time, new_time)

      if Game.use_collisions
        @handle_collisions(player) for player in @players

      @render_game if @browser

      @old_time = new_time

    addListener: (listener) ->
      @listeners.push(listener)

  Game
)
