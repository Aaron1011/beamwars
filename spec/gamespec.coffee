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

    timeToTraverse = null

    beforeEach(() ->
      game = new Game()
      timeToTraverse = Game.WIDTH / Game.VELOCITY
      game.start()
    )

    it "starts players in the correct starting posititon", ->
      expect([new Position([Game.WIDTH/2, 0], Point.SOUTH, 0),
              new Position([Game.WIDTH, Game.HEIGHT/2], Point.WEST, 0),
              new Position([Game.WIDTH/2, Game.HEIGHT], Point.NORTH, 0),
              new Position([0, Game.HEIGHT/2], Point.EAST, 0)]).toEqual(game.getPositions())


    it "turns players correctly", ->
      SynchronizedTime.setTimeForTesting(timeToTraverse / 4.0)
      game.timer_tick()
      game.handle_input(0, KEY_WEST)
      SynchronizedTime.setTimeForTesting(SynchronizedTime.getTime() + timeToTraverse / 8.0)
      game.timer_tick()

      expect([game.player0.currentPosition().x, game.player0.currentPosition().y]).toEqual(
          [Game.WIDTH * 0.375, Game.HEIGHT * 0.25])
      expect([game.player1.currentPosition().x, game.player1.currentPosition().y]).toEqual(
          [Game.WIDTH * 0.625, Game.HEIGHT * .5])

  
    it "allows last turn insertion", ->
      SynchronizedTime.setTimeForTesting(timeToTraverse * .375)
      game.timer_tick()
      game.handle_input(0, KEY_EAST, SynchronizedTime.getTime() - timeToTraverse / 8.0)
      expect([game.player0.currentPosition().x, game.player0.currentPosition().y]).toEqual(
          [Game.WIDTH * .625, Game.HEIGHT * .25])


    it "doesn't allow inserting a turn before the last one", ->
      SynchronizedTime.setTimeForTesting(timeToTraverse * .375)
      game.timer_tick()
      game.handle_input(0, KEY_EAST)
      try
        game.handle_input(0, KEY_EAST, SynchronizedTime.getTime() - timeToTraverse / 8.0)
        @fail(Error('An illegal turn was allowed'))
      catch e
        expect(e.message).toEqual('IllegalTurnException') # TODO: Make constant


    it "accurately reports the position of a player at any time in the past", ->
      pos = game.player0.currentPosition(0)
      expect([pos.x, pos.y]).toEqual([Game.WIDTH / 2, 0])
      pos = game.player0.currentPosition(timeToTraverse / 2)
      expect([pos.x, pos.y]).toEqual([Game.WIDTH / 2, Game.HEIGHT / 2])

      SynchronizedTime.setTimeForTesting(timeToTraverse / 2)
      game.handle_input(0, KEY_WEST)
      pos = game.player0.currentPosition(timeToTraverse * .75)
      expect([pos.x, pos.y]).toEqual([Game.WIDTH *.25, Game.HEIGHT * .5])






    xdescribe "collision behavior", ->
      listener = null

      beforeEach(() ->
        listener = jasmine.createSpyObj('listener', ['notify'])
        SynchronizedTime.setTimeForTesting(0)
        game.addListener(listener)
      )
       

      it "notifies the listeners about a head-collision for the current player", ->

        SynchronizedTime.setTimeForTesting(timeToTraverse * .375)
        game.timer_tick()
        game.handle_input(0, KEY_EAST)
        game.handle_input(2, KEY_WEST)
        SynchronizedTime.setTimeForTesting(timeToTraverse * .55)
        game.timer_tick()
        expect(listener.notify).toHaveBeenCalledWith(game.player1, game.player3, new Point(Game.WITDTH/2, Game.HEIGHT/2))

      it "notifies the listeners about a one-way collision for the current player", ->
        SynchronizedTime.setTimeForTesting(timeToTraverse * .375)
        game.timer_tick()
        game.handle_input(0, KEY_EAST)
        game.handle_input(1, KEY_SOUTH)
        game.handle_input(2, KEY_WEST)
        SynchronizedTime.setTimeForTesting(timeToTraverse * .63)
        game.timer_tick()
        expect(listener.notify).toHaveBeenCalledWith(game.player3, game.player1, new Point(Game.WIDTH * .63, Game.HEIGHT/2))

      it "notifies the listeners about a collision coming from another player", ->
        SynchronizedTime.setTimeForTesting(timeToTraverse * .375)
        game.timer_tick()
        game.handle_input(0, KEY_EAST)
        game.handle_input(2, KEY_WEST)
        SynchronizedTime.setTimeForTesting(timeToTraverse * .55)
        game.handleCollisionMessage(2, 0)
        game.timer_tick()
        expect(listener.notify).toHaveBeenCalledWith(game.player0, game.player1, new Point(Game.WITDTH/2, Game.HEIGHT/2))

)
