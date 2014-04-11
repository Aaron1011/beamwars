requirejs.config({
    baseUrl: './src',
    nodeRequire: require
    shim: {
      'underscore': {
        exports: 'underscore'
      }
    }
    paths: {
        underscore: 'lib/underscore',
        fabric: 'lib/fabric'
    }
})


define(['fabric', 'point', 'underscore'], (fabric, Point, _) ->
  fabric = fabric.fabric if fabric.fabric?

  VERTICAL = 'v'
  HORIZONTAL = 'h'

  UP = 'u'
  DOWN = 'd'
  LEFT = 'l'
  RIGHT = 'r'

  exports = {}

  class WallSegment
    constructor: (@startpoint, @endpoint, @player) ->
      if @startpoint.x == @endpoint.x
        @orientation = VERTICAL
      else
        @orientation = HORIZONTAL

    extend: (segment) ->
      if not segment.startpoint.eq(@endpoint)
        throw Error('IllegalExtendException')
      @endpoint = segment.endpoint

    truncate: (segment) ->
      if segment.orientation == @orientation
        throw Error('SameOrientationTruncateException')
      if segment.orientation == VERTICAL
        @endpoint.x = segment.startpoint.x
      else
        @endpoint.y = segment.startpoint.y

    intersection_with: (segment) ->
      if segment.orientation == @orientation
        throw new Error('The segments must have different orientations')

      intersection = fabric.Intersection.intersectLineLine(@startpoint, @endpoint, segment.startpoint, segment.endpoint)
      return [this, segment, intersection.points[0]] if intersection.status == "Intersection"
      return false

  class Walls
    constructor: (@Game) ->
      @walls = { 'v': [], 'h': [] }
      @most_recent_walls = [null, null, null, null]

    update_wall: (player_no, segment) ->
      last_wall = @most_recent_walls[player_no]
      if last_wall? and segment.orientation == last_wall.orientation
        last_wall.extend(segment)
      else
        if last_wall?
          last_wall.truncate(segment)
        @most_recent_walls[player_no] = segment
        @walls[segment.orientation].push(segment)

    detect_collisions: (segment) ->
      collisions = []
      if segment.orientation == HORIZONTAL
        orientation_to_search = VERTICAL
      else
        orientation_to_search = HORIZONTAL

      walls_to_search = @walls[orientation_to_search]

      searched = []

      for wall in _.without(@most_recent_walls, null)
        #console.log "Wall: ", wall
        for wall2 in _.without(@most_recent_walls, wall, null, searched...)
          #console.log "Wall2: ", wall2
          if wall.orientation == wall2.orientation
            if (wall.orientation == HORIZONTAL and wall.startpoint.y == wall2.startpoint.y)
              overlap = _.min([_.max([wall.startpoint.x, wall.endpoint.x]), _.max([wall2.startpoint.x, wall2.endpoint.x])]) - _.max([_.min([wall2.startpoint.x, wall2.endpoint.x]), _.min([wall.startpoint.x, wall.endpoint.x])])
            else if (wall.orientation == VERTICAL and wall.startpoint.x == wall2.startpoint.x)
              overlap = _.min([_.max([wall.startpoint.y, wall.endpoint.y]), _.max([wall2.startpoint.y, wall2.endpoint.y])]) - _.max([_.min([wall2.startpoint.y, wall2.endpoint.y]), _.min([wall.startpoint.y, wall.endpoint.y])])

            #console.log "Overlap: ", overlap
            if overlap > 0
              #console.log "We have overlap!"
              collisions.push([wall, wall2, overlap])
              collisions.push([wall2, wall, overlap])

        searched.push(wall)

      for wall in walls_to_search
        continue if wall.endpoint.x == segment.player.lastPos().x and wall.endpoint.y == segment.player.lastPos().y
        intersect = segment.intersection_with(wall)
        collisions.push(intersect) if intersect? and intersect != false
      collisions


    ###
    Don't use
    add_or_extend_wall: (player, position) ->
      @walls[player.name] ||= {0: [], 1: [], 2: [], 3: []}
      console.log "Walls: ", @walls[player.name][position.direction] if player.name == "Player0"
      for wall in @walls[player.name][position.direction]
        if position.direction == Point.NORTH or position.direction == Point.SOUTH
          if wall.startpoint.x == position.x
            if wall.startpoint.y < position.y
              wall.endpoint.y = position.y
            else
              wall.startpoint.y = position.y
            return
        else
          if wall.startpoint.y == position.y
            if wall.startpoint.x < position.x
              wall.endpoint.x = position.x
            else
              wall.startpoint.x = position.x
            return
      console.log "New wall!"
      @walls[player.name][position.direction].push(new Wall(position, position))

    is_collision: (segment) ->

   ###


    allWalls: ->
      @walls['v'].concat(@walls['h'])

  exports.Walls = Walls
  exports.WallSegment = WallSegment

  exports
)
