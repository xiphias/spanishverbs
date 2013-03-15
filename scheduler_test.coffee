require ["scheduler"], (Scheduler) ->

  test "Sheduler", ->
      s = new Scheduler([{f: 0}, {f: 1}, {f: 3}])
      s.userEvent {features: {f: 1}, good: false, timestamp: 0}
      equal s.probability({f: 0}, 10), 0
      ok s.probability({f: 1}, 10) > 0.1
      ok s.probability({f: 1}, 10) < 0.8
      equal s.best(10).features.f, 1
      equal s.mapToKey({a: 1, b: 2}), s.mapToKey({b: 2, a: 1})