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
        stroke: 'blue',
        strokeWidth: 5,
        fille: 'white'
        left: 0
        top: 0
      })
      @inCanvas = true

    lastPos: ->
      @positions[@positions.length - 1]

    clearLine: ->
      @current_line.points = []
      @canvas.remove(@current_line)
      @inCanvas = false

    currentLine: ->
      @current_line.points.slice() # Copy array

    currentLinePos: ->
      return [] unless @current_line.points.length > 0
      @current_line.points[@current_line.points.length - 1]

    addToLine: (pos) ->
      @canvas.add(@current_line) unless @inCanvas
      @inCanvas = true
      @current_line.points.push(pos)

  Player
)
