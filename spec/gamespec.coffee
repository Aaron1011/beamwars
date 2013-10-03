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
      Game.VELOCITY = 1
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
      expect(game.getCurrentLines()).toEqual([[new Position([Game.WIDTH/2, 0 + Game.VELOCITY*.1], Game.SOUTH, .1)],
                                             [new Position([Game.WIDTH - Game.VELOCITY*.1, Game.HEIGHT/2], Game.WEST, .1)],
                                             [new Position([Game.WIDTH/2, Game.HEIGHT - Game.VELOCITY*.1], Game.NORTH, .1)],
                                             [new Position([0 + Game.VELOCITY*.1, Game.HEIGHT/2], Game.EAST, .1)]])

    it "notifies the listeners about a collision", ->
      listener = jasmine.createSpyObj('listener', ['notify'])
      SynchronizedTime.setTimeForTesting(0)
      game.addListener(listener)
      game.start()
      game.player0.addToLine(new Position([1, 0], Game.EAST, 0))
      game.player1.addToLine(new Position([3, 0], Game.WEST, 0))
      SynchronizedTime.setTimeForTesting(1)
      game.timer_tick()
      expect(listener.notify).toHaveBeenCalledWith(game.player1, game.player0, new Point(2,0))
      expect(listener.notify).toHaveBeenCalledWith(game.player0, game.player1, new Point(2,0))
)
