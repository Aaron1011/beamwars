define(['fabric'], (fabric) ->
  fabric = fabric.fabric if fabric.fabric?

  VERTICAL = 'v'
  HORIZONTAL = 'h'

  UP = 'u'
  DOWN = 'd'
  LEFT = 'l'
  RIGHT = 'r'

  exports = {}

  class WallSegment
    constructor: (@endpoint1, @endpoint2, @player) ->
      if @endpoint1.x == @endpoint2.x
        @orientation = VERTICAL
      else
        @orientation = HORIZONTAL

    extend: (segment) ->
      if segment.orientation == VERTICAL
        if segment.endpoint1.y < @endpoint1.y
          @endpoint1 = segment.endpoint1
        else
          @endpoint2 = segment.endpoint2
      else
        if segment.endpoint1.x < @endpoint1.x
          @endpoint1 = segment.endpoint1
        else
          @endpoint2 = segment.endpoint2

    truncate: (segment) ->
      if segment.orientation == VERTICAL
        @endpoint2.x = segment.endpoint1.x
      else
        @endpoint2.y = segment.endpoint1.y

    intersection_with: (segment) ->
      intersection = fabric.Intersection.intersectLineLine(@endpoint1.pos, @endpoint2.pos, segment.endpoint1.pos, segment.endpoint2.pos)
      return [this, segment] if intersection.status == "Intersection" || intersection.status == "Coincident"
      return false

  class Walls
    constructor: (@Game) ->
      @walls = { 'v': [], 'h': [] }
      @most_recent_walls = [null] * @Game.players.length

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
        orientation_to_search = VERTICAL
      walls_to_search = @walls[orientation_to_search].slice()
      walls_to_search.splice(walls_to_search.indexOf(segment), 1)
      for wall in walls_to_search
        intersect = segment.intersection_with(wall)
        collisions.push(intersect) if intersect != null
      collisions



    add_or_extend_wall: (player, position) ->
      @walls[player.name] ||= {0: [], 1: [], 2: [], 3: []}
      console.log "Walls: ", @walls[player.name][position.direction] if player.name == "Player0"
      for wall in @walls[player.name][position.direction]
        if position.direction == @Game.NORTH or position.direction == @Game.SOUTH
          if wall.endpoint1.x == position.x
            if wall.endpoint1.y < position.y
              wall.endpoint2.y = position.y
            else
              wall.endpoint1.y = position.y
            return
        else
          if wall.endpoint1.y == position.y
            if wall.endpoint1.x < position.x
              wall.endpoint2.x = position.x
            else
              wall.endpoint1.x = position.x
            return
      console.log "New wall!"
      @walls[player.name][position.direction].push(new Wall(position, position))

    is_collision: (segment) ->

  exports.Walls = Walls
  exports.WallSegment = WallSegment

  exports
)
