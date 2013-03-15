define "linear_interpolator", ->
  
  class LinearInterpolator
    constructor: (xs, ys=null) ->
      if ys
        @xs = xs
        @ys = ys
      else
        @xs = _.map(_.keys(xs), (x) -> parseFloat(x)).sort()
        @ys = _.map(@xs, (x) -> xs[x])

    simpleInterpolate: (x, x0, x1, y0, y1) ->
      y0 + (y1 - y0) * (x - x0) / (x1 - x0)

    at: (x) ->
      if (@xs.length == 0)
        return 0
      if (@xs.length == 1)
        return @ys[0]
      if (x <= @xs[0])
        #return simpleInterpolate(x, xs[0], xs[1], ys[0], ys[1])
        return @ys[0]
      if (x >= @xs[@xs.length - 1])
        return @ys[@ys.length - 1]
      min = 0
      max = @xs.length - 2
      while (min != max)
        n = Math.floor((max + min + 1) / 2)
        if x >= @xs[n]
          min = n
        else
          n = max = n - 1
      @simpleInterpolate(x, @xs[n], @xs[n + 1], @ys[n], @ys[n+1])



  return LinearInterpolator

