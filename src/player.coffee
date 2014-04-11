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

define(['fabric', 'synchronizedtime', 'point'], (fabric, SynchronizedTime, Point) ->
  fabric = fabric.fabric if fabric.fabric?

  class Player

    constructor: (@name, pos, @game, @id) ->
      @positions = [pos]
      @lastPoint = new Point(pos.x, pos.y)
      @alive = true

    lastPos: ->
      @positions[@positions.length - 1]


    currentPosition: (time=SynchronizedTime.getTime()) ->
      lastpos = @positions[@positions.length - 1]
      distance = (time - lastpos.time) * @game.constructor.VELOCITY
      #@lastPoint = lastpos.pos.add(Point.unit_vector(lastpos.direction).multiply(distance))
      lastpos.pos.add(Point.unit_vector(lastpos.direction).multiply(distance))



    resetLine: ->
      new_line = @currentLine()
      lastpos = @lastPos()
      old_time = lastpos.time
      for pos in new_line
        if pos.time > lastpos.time
          @game.move_player(this, pos.time - old_time, pos.time, lastpos)
          old_time = pos.time
        else
          @unverified_positions.splice(@unverified_positions.indexOf(pos), 1)

    setupLine: ->
      @current_line.points = @completeLine()

    completeLine: ->
      @positions.concat(@unverified_positions)

  Player
)
