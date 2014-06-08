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
        console.error("Illegal extend")
        #throw Error('IllegalExtendException')
      @endpoint = segment.endpoint

    truncate: (segment) ->
      if segment.orientation == @orientation
        console.error("Same orientation truncate")
        #throw Error('SameOrientationTruncateException')
      if segment.orientation == VERTICAL
        @endpoint.x = segment.startpoint.x
      else
        @endpoint.y = segment.startpoint.y

    intersection_with: (segment) ->
      if segment.orientation == @orientation
        console.error "Same orientation intersection check"
        #throw new Error('The segments must have different orientations')

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
        console.log "Walls: ", @walls[segment.orientation]
        @most_recent_walls[player_no] = last_wall
      else
        console.log "Walls 2: ", @walls[segment.orientation]
        if last_wall?
          last_wall.truncate(segment)
        @most_recent_walls[player_no] = segment
        @walls[segment.orientation].push(segment)

    removePlayer: (player) ->
      console.log "Removing player!"
      for wall in @allWalls()
        if wall.player == player
          console.log "Wall gone!"
          @walls[wall.orientation].splice(@walls[wall.orientation].indexOf(wall), 1)

    detect_collisions: (segment) ->
      collisions = []
      if segment.orientation == HORIZONTAL
        orientation_to_search = VERTICAL
      else
        orientation_to_search = HORIZONTAL

      walls_to_search = @walls[orientation_to_search]

      for wall2 in _.without(@most_recent_walls, segment, null)
        #console.log "Wall2: ", wall2
        if segment.orientation == wall2.orientation and segment.player != wall2.player
          if (segment.orientation == HORIZONTAL and segment.startpoint.y == wall2.startpoint.y)
            overlap = _.min([_.max([segment.startpoint.x, segment.endpoint.x]), _.max([wall2.startpoint.x, wall2.endpoint.x])]) - _.max([_.min([wall2.startpoint.x, wall2.endpoint.x]), _.min([segment.startpoint.x, segment.endpoint.x])])
          else if (segment.orientation == VERTICAL and segment.startpoint.x == wall2.startpoint.x)
            overlap = _.min([_.max([segment.startpoint.y, segment.endpoint.y]), _.max([wall2.startpoint.y, wall2.endpoint.y])]) - _.max([_.min([wall2.startpoint.y, wall2.endpoint.y]), _.min([segment.startpoint.y, segment.endpoint.y])])

          #console.log "Overlap: ", overlap
          if overlap > 0
            collisions.push([segment, wall2, overlap])
            collisions.push([wall2, segment, overlap])
            console.log "Collisionsa: ", segment, wall2

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
