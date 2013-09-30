class SynchronizedTime

  @time = 0.0

  @setTimeForTesting: (t) ->
    SynchronizedTime.time = t

  @getTime: -> SynchronizedTime.time

window.SynchronizedTime = SynchronizedTime
