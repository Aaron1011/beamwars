class Game

  @NORTH = 0
  @SOUTH = 1
  @EAST = 2
  @WEST = 3

  @WIDTH:  200
  @HEIGHT:  300

  @VELOCITY = 0.1

  @listeners = []
  @players = []

  start: ->
    @player0 = new Player(new Position([Game.WIDTH/2, 0], Game.SOUTH, 0))
    @player1 = new Player(new Position([Game.WIDTH, Game.HEIGHT/2], Game.WEST, 0))
    @player2 = new Player(new Position([Game.WIDTH/2, Game.HEIGHT], Game.NORTH, 0))
    @player3 = new Player(new Position([0, Game.HEIGHT/2], Game.EAST, 0))

    @players = [@player0, @player1, @player2, @player3]

    @old_time = SynchronizedTime.getTime()


  key_down: (player, key, coord) ->

  getPositions: ->
    p.lastPos() for p in @players

  getCurrentLines: ->
    p.current_line for p in @players

  add_listener: (listener) ->
    @listeners.append(listener)

window.Game = Game
