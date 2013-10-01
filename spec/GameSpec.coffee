requirejs.config({
    baseUrl: '../',
    #paths: {
    #  'paper': 'lib/paper'
    #}
    #shim: {
    #  'paper': {
    #    "exports": 'paper'
    #  }
    #}
})

require(['position', 'game', 'synchronizedtime', 'point'], (Position, Game, SynchronizedTime, Point) ->
  describe "Game", ->
    game = null

    beforeEach(() ->
      game = new Game()
    )

    it "starts players in the correct starting posititon", ->
      game.start()
      expect([new Position([Game.WIDTH/2, 0], Game.SOUTH, 0),
              new Position([Game.WIDTH, Game.HEIGHT/2], Game.WEST, 0),
              new Position([Game.WIDTH/2, Game.HEIGHT], Game.NORTH, 0),
              new Position([0, Game.HEIGHT/2], Game.EAST, 0)]).toEqual(game.getPositions())


    it "moves players foward after timer tick", ->
      SynchronizedTime.setTimeForTesting(0)
      game.start()
      expect(game.getCurrentLines()).toEqual([ [], [], [], [] ])
      SynchronizedTime.setTimeForTesting(0.1)
      game.timer_tick()
      expect(game.getCurrentLines()).toEqual([[new Point(Game.WIDTH/2 + Game.VELOCITY*.1, 0)],
                                             [new Point(Game.WIDTH, Game.HEIGHT/2 - Game.VELOCITY*.1)],
                                             [new Point(Game.WIDTH/2 - Game.VELOCITY*.1, Game.HEIGHT)],
                                             [new Point(0, Game.HEIGHT/2 + Game.VELOCITY*.1)]])
)
