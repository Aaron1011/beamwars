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
      expect([new Position([Game.WIDTH/2, 0], Point.SOUTH, 0),
              new Position([Game.WIDTH, Game.HEIGHT/2], Point.WEST, 0),
              new Position([Game.WIDTH/2, Game.HEIGHT], Point.NORTH, 0),
              new Position([0, Game.HEIGHT/2], Point.EAST, 0)]).toEqual(game.getPositions())


    it "turns players correctly", ->
      game.start()
      timeToTraverse = Game.WIDTH / Game.VELOCITY
      SynchronizedTime.setTimeForTesting(timeToTraverse / 4.0)
      game.timer_tick()
      game.storeKeyPress(KEY_WEST)
      game.handle_input(SynchronizedTime.getTime())
      SynchronizedTime.setTimeForTesting(SynchronizedTime.getTime() + timeToTraverse / 8.0)
      game.timer_tick()

      expect([game.player0.currentPosition().x, game.player0.currentPosition().y]).toEqual(
          [Game.WIDTH * 0.375, Game.HEIGHT * 0.25])
      expect([game.player1.currentPosition().x, game.player1.currentPosition().y]).toEqual(
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
        game.player0.addToLine(new Position([1, 0], Point.EAST, 0))
        game.player1.addToLine(new Position([3, 0], Point.WEST, 0))
        SynchronizedTime.setTimeForTesting(1)
        game.timer_tick()
        expect(listener.notify).toHaveBeenCalledWith(game.player1, game.player0, new Point(2,0))
        expect(listener.notify).toHaveBeenCalledWith(game.player0, game.player1, new Point(2,0))

      it "notifies the listeners about a one-way collision for the collided player", ->
        game.player0.addToLine(new Position([0, 0], Point.EAST, 0))
        game.player1.addToLine(new Position([0, 1], Point.NORTH, 0))
        SynchronizedTime.setTimeForTesting(1)
        game.timer_tick()
        expect(listener.notify).toHaveBeenCalledWith(game.player1, game.player0, new Point(0,0))
        expect(listener.notify).not.toHaveBeenCalledWith(game.player0, game.player1, new Point(0,0))
)
