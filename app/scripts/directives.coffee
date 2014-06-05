'use strict'

### Directives ###

# register the module with Angular
angular.module('app.directives', [
  # require the 'app.service' module
  'app.services'
])

.directive('appVersion', [
  'version'

(version) ->

  (scope, elm, attrs) ->
    elm.text(version)
])
.directive "theoreticalPlot", ($parse) ->
    {
    # restricting to an element
    restrict: "E"
    replace: false
    link: (scope, element, attrs) ->
        beta = 0.08
        gamma = (b) ->
            ((Math.PI^3) / 3) * (b / (1 - 2 * Math.PI * b))
        df = (a) ->
            Math.exp(gamma(beta) * (1 - 1 / a))
        xs = d3.range(0.01, 0.99, 0.01)
        data = xs.map (x) -> [x, df(x)]
        data = [
            {
                name: "theory"
                values: data
            }
        ]
        width = element[0].offsetWidth
        console.log width
        graph = d3.chart.line()
            .width width
            .height 0.618 * width
        element
            .data [data]
            .call graph
    }
