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

define(['game'], (Game) ->

  class Point
    constructor: (@x, @y) ->

    @unit_vector: (direction) ->
      if direction == Game.NORTH
        new Point(0, 1)
      else if direction == Game.SOUTH
        new Point(0, -1)
      else if direction == Game.WEST
        new Point(-1, 0)
      else
        new Point(1, 0)

    multiply: (scalar) ->
      new Point(@x * scalar, @y * scalar)

    add: (point) ->
      new Point(@x + point.x, @y + point.y)

  Point
)
