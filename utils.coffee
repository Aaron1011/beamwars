define [], ->
  # Taken from http://stackoverflow.com/a/12628791/1290530
  cartProd = (paramArray) ->

    addTo = (curr, args) ->

      rest = args.slice(1)
      last = !rest.length
      result = []

      for i in [0...args[0].length]

        copy = curr.slice()
        copy.push(args[0][i])

        if (last)
          result.push(copy)

        else
          result = result.concat(addTo(copy, rest))



      return result


    return addTo([], Array.prototype.slice.call(arguments))

  {cartProd: cartProd}
