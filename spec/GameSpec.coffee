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

require(['position', 'game', 'synchronizedtime'], (Position, Game, SynchronizedTime) ->
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
      a = game.getCurrentLines()
      console.log(a)
      SynchronizedTime.setTimeForTesting(0.1)
      console.log "Updated time!"
      game.timer_tick()
      b = game.getCurrentLines()
      console.log(b)
      expect(a).toEqual(b)
)
