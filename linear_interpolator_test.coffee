require ["linear_interpolator"], (LinearInterpolator) ->
  test "LinearInterpolator", () ->
      i = new LinearInterpolator([2, 4, 5], [3, 4, 9])
      equal i.at(2), 3
      equal i.at(3), 3.5
      equal i.at(4.5), 6.5
      equal i.at(4.5), 6.5
      equal i.at(-3), 3
      equal i.at(8), 9

      ih = new LinearInterpolator({2: 3, 4: 4, 5: 9})
      equal ih.at(3), 3.5

      inverse_short_memory_table = new LinearInterpolator({1: 0, 0.9 : 1, 0.7 : 5, 0.2 : 7, 0.01 : 10, 0.0001 : 100, 0 : 100000})
      notStrictEqual inverse_short_memory_table.at(0.99), 0.1
           