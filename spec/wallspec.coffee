requirejs.config({
  #baseUrl: '../',
})

require(['game', 'walls', 'synchronizedtime'], (Game, Walls, SynchronizedTime) ->
  describe "Walls", ->
    game = null
    wall = null

    beforeEach ->
      game = new Game()
      walls = new Walls()
      Game.VELOCITY = 1

    it "", ->
      SynchronizedTime.setTimeForTesting(0)
      game.start()
)
