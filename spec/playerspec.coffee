requirejs.config({
  #baseUrl: '../',
})

define(['player'], (Player) ->
    describe "Player", ->
      player = null

      it "adds points to current_line", ->
        player = new Player('Player0', 'Pos')
        player.addToLine('Pos2')
        player.addToLine('Pos3')
        expect(player.currentLinePos()).toEqual('Pos3')
        expect(player.currentLine()).toEqual(['Pos2', 'Pos3'])
)
