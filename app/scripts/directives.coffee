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

.directive "theoreticalPlot", [
    "$parse"
    "comptonService"
    ($parse, comptonService) ->
        {
        # restricting to an element
        restrict: "E"
        replace: false
        link: (scope, element, attrs) ->
            width = element[0].clientWidth
            scope.graph
                .width width
                .height 0.618 * width
            d3.select element[0]
                .data [scope.data]
                .call scope.graph
        }
    ]

.directive "noisePlot", ($parse, comptonService) ->
    {
    # restricting to an element
    restrict: "E"
    replace: false
    link: (scope, element, attrs) ->

        beta = 0.08
        v0 = scope.visibility / 100
        n0 = scope.counts
        r = 0.5 # measured by Zhentian at low energies
        draw_graph = (v0, n0) ->
            max_y = 3
            min_x = bisect(
                (a) -> comptonService.sigma_phi(a, v0, n0) < max_y,
                0.01,
                0.99)
            min_x_no_compton = bisect(
                (a) -> comptonService.sigma_phi_no_compton(a, v0, n0, r) < max_y,
                0.01,
                0.99)
            xs = d3.range(d3.round(min_x, 2), 0.99, 0.01)
            full_range = d3.range(d3.round(min_x_no_compton, 2), 0.99, 0.01)
            sigma_max = 2 * Math.PI / 5
            data = [
                {
                    name: "with Compton"
                    values: xs.map (x) ->
                        [x, comptonService.sigma_phi(x, v0, n0)]
                },
                {
                    name: "without Compton"
                    values: full_range.map (x) ->
                        [x, comptonService.sigma_phi_no_compton(x, v0, n0, r)]
                },
                {
                    name: "Rose threshold"
                    values: [[0, sigma_max], [1, sigma_max]]
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
            scope.minimum_transmission = bisect(
                (a) -> comptonService.sigma_phi(a, v0, n0) < sigma_max,
                0.01,
                0.99)
            scope.minimum_transmission_no_compton = bisect(
                (a) -> comptonService.sigma_phi_no_compton(a, v0, n0, r) < sigma_max,
                0.01,
                0.99)
            scope.energy = 100

        scope.$watch "visibility", (v, oldvalue) ->
            v0 = v / 100
            draw_graph v0, n0
        scope.$watch "counts", (n, oldvalue) ->
            n0 = n
            draw_graph v0, n0
    }
