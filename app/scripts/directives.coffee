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
            (Math.pow(Math.PI, 3) / 3) * (b / (1 - 2 * Math.PI * b))
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
        width = element[0].clientWidth
        graph = d3.chart.line()
            .width width
            .height 0.618 * width
            .legend_square_size undefined
            .x_title "transmission"
            .y_title "dark field"
        d3.select element[0]
            .data [data]
            .call graph
    }
.directive "noisePlot", ($parse) ->
    {
    # restricting to an element
    restrict: "E"
    replace: false
    link: (scope, element, attrs) ->
        beta = 0.08
        v0 = 0.1
        n0 = 10000
        gamma = (b) ->
            (Math.pow(Math.PI, 3) / 3) * (b / (1 - 2 * Math.PI * b))
        df = (a) ->
            Math.exp(gamma(beta) * (1 - 1 / a))
        sigma_phi = (a) ->
            (1 / (v0 * Math.sqrt(n0 * a) * df(a)))
        xs = d3.range(0.30, 0.99, 0.01)
        full_range = d3.range(0.01, 0.99, 0.01)
        data = xs.map (x) -> [x, sigma_phi(x)]
        sigma_max = 2 * Math.PI / 5
        data = [
            {
                name: "noise with Compton"
                values: data
            },
            {
                name: "noise without Compton"
                values: full_range.map (d) -> [d, 1 / (v0 * d * Math.sqrt(n0 * d))]
            },
            {
                name: "Rose threshold"
                values: full_range.map (x) -> [x, sigma_max]
            }
        ]
        width = element[0].clientWidth
        graph = d3.chart.line()
            .width width
            .height 0.618 * width
            .x_title "transmission"
            .y_title "differential phase noise"
        graph
            .y_scale()
            .domain [0, 3]
        d3.select element[0]
            .data [data]
            .call graph
    }
.directive "maximumThicknessTable", ($parse) ->
    {
    # restricting to an element
    restrict: "E"
    replace: false
    link: (scope, element, attrs) ->
    }
