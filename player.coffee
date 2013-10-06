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

define(['fabric', 'game'], (fabric, Game) ->
  fabric = fabric.fabric if fabric.fabric?

  class Player

    constructor: (@name, pos, @canvas, @game) ->
      @positions = []
      @positions.push(pos)
      @unverified_positions = []
      @current_line = new fabric.Polyline([], {
        stroke: 'blue',
        strokeWidth: 5,
        fill: 'white'
        left: 0
        top: 0
      })

    lastPos: ->
      @positions[@positions.length - 1]

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

    currentLine: ->
      @unverified_positions.slice() # Copy array

    currentLinePos: ->
      return [] unless @unverified_positions.length > 0
      @unverified_positions[@unverified_positions.length - 1]

    addToLine: (pos) ->
      @unverified_positions.push(pos)

    setupLine: ->
      @current_line.points = @completeLine()

    completeLine: ->
      @positions.concat(@unverified_positions)

  Player
)
