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

        scope.$watch "graph", ->
            width = element[0].clientWidth
            scope.graph
                .width width
                .height 0.618 * width

            d3.select element[0]
                .data [scope.data]
                .call scope.graph
    }

.directive "mathjaxBind", ->
    {
        restrict: "E"
        link: (scope, element, attrs) ->
            MathJax.Hub.Queue ["Typeset", MathJax.Hub]

    }
