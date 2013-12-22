requirejs.config({
    #baseUrl: 'beamwars/',
    #paths: {
    #  'paper': 'lib/paper'
    #}
    #shim: {
    #  'paper': {
    #    "exports": 'paper'
    #  }
    #}
})

define(['position', 'game', 'synchronizedtime', 'point'], (Position, Game, SynchronizedTime, Point) ->
  describe "Game", ->
    game = null
    KEY_WEST = 37
    KEY_NORTH = 38
    KEY_EAST = 39
    KEY_SOUTH = 40

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


    it "turns players correctly", ->
      game.start()
      timeToTraverse = Game.WIDTH / Game.VELOCITY
      SynchronizedTime.setTimeForTesting(timeToTraverse / 4.0)
      game.timer_tick()
      game.keyDown(game.player0, KEY_WEST, game.player0.currentLinePos())
      SynchronizedTime.setTimeForTesting(SynchronizedTime.getTime() + timeToTraverse / 8.0)
      game.timer_tick()

      expect([game.player0.currentLinePos().x, game.player0.currentLinePos().y]).toEqual(
          [Game.WIDTH * 0.375, Game.HEIGHT * 0.25])
      expect([game.player1.currentLinePos().x, game.player1.currentLinePos().y]).toEqual(
          [Game.WIDTH * 0.625, Game.HEIGHT * .5])


    describe "listener", ->
      listener = null

      beforeEach(() ->
        listener = jasmine.createSpyObj('listener', ['notify'])
        SynchronizedTime.setTimeForTesting(0)
        game.addListener(listener)
        game.start()
      )

      it "notifies the listeners about a head-collision for each player", ->
        game.player0.addToLine(new Position([1, 0], Game.EAST, 0))
        game.player1.addToLine(new Position([3, 0], Game.WEST, 0))
        SynchronizedTime.setTimeForTesting(1)
        game.timer_tick()
        expect(listener.notify).toHaveBeenCalledWith(game.player1, game.player0, new Point(2,0))
        expect(listener.notify).toHaveBeenCalledWith(game.player0, game.player1, new Point(2,0))

      it "notifies the listeners about a one-way collision for the collided player", ->
        game.player0.addToLine(new Position([0, 0], Game.EAST, 0))
        game.player1.addToLine(new Position([0, 1], Game.NORTH, 0))
        SynchronizedTime.setTimeForTesting(1)
        game.timer_tick()
        expect(listener.notify).toHaveBeenCalledWith(game.player1, game.player0, new Point(0,0))
        expect(listener.notify).not.toHaveBeenCalledWith(game.player0, game.player1, new Point(0,0))
)
