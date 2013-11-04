requirejs.config({
    baseUrl: '../',
})

require(['game', 'walls', 'synchronizedtime'], (Game, Walls, SynchronizedTime) ->
  describe "Walls", ->
    game = null

    beforeEach ->
      game = new Game()
      Game.VELOCITY = 1

    it "detects a collision", ->
      SynchronizedTime.setTimeForTesting(0)
      game.start()

