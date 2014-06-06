'use strict'

### Sevices ###

angular.module('app.services', [])

.factory 'version', -> "0.1"
.factory 'bisect', ->
    {
        bisect: (predicate, low, high, tol=1e-6) ->
            # Supposing that predicate is monotone over the interval
            # [low,high), finds the first occurence of where predicate is true
            # up to a resolution of tolerance.
            while high - low > tol
                m = (high + low) / 2
                if predicate(m)
                    high = m
                else
                    low = m
            return low
    }
