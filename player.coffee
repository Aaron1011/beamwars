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

define(['fabric'], (fabric) ->
  fabric = fabric.fabric if fabric.fabric?

  class Player

    constructor: (@name, pos, @canvas) ->
      @positions = []
      @positions.push(pos)
      @current_line = new fabric.Polyline([], {
        stroke: 'black',
        stokeWidth: 3,
        fille: 'white'
        left: 200
        top: 200
      })

    lastPos: ->
      @positions[@positions.length - 1]

    currentLine: ->
      @current_line.points.slice() # Copy array

    currentLinePos: ->
      @current_line.points[@current_line.points.length - 1]

    addToLine: (pos) ->
      @current_line.points.push(pos)

  Player
)
