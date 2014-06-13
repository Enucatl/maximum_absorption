'use strict'

### Controllers ###

angular.module('app.controllers',
    ['app.services'])

    .controller('AppCtrl', [
        '$scope'
        '$location'
        '$resource'
        '$rootScope'

        ($scope, $location, $resource, $rootScope) ->

            # Uses the url to determine if the selected
            # menu item should have the class active.
            $scope.$location = $location
            $scope.$watch('$location.path()', (path) ->
                $scope.activeNavId = path || '/'
            )

            $scope.expression = "\\( \\frac{4}{5} \\)"


            # getClass compares the current url with the id.
            # If the current url starts with the id it returns 'active'
            # otherwise it will return '' an empty string. E.g.
            #
            #   # current url = '/products/1'
            #   getClass('/products') # returns 'active'
            #   getClass('/orders') # returns ''
            #
            $scope.getClass = (id) ->
                if $scope.activeNavId.substring(0, id.length) == id
                    return 'active'
                else
                    return ''

    ])

    .controller('TheoreticalPlotCtrl', [
        '$scope'
        'comptonService'

        ($scope, comptonService) ->
            beta = 0.08
            xs = d3.range(0.01, 0.99, 0.01)
            data = xs.map (x) -> [x, comptonService.df(x, beta)]
            $scope.data = [
                {
                    name: "theory"
                    values: data
                }
            ]
            $scope.graph = d3.chart.line()
                .legend_square_size undefined
                .x_title "transmission"
                .y_title "dark field"

        ])

    .controller 'MaximumThicknessCtrl', [
        '$scope'
        '$timeout'
        'Table'
        'comptonService'
        'thicknessCalculatorService'

        ($scope, $timeout, Table, comptonService, thicknessCalculatorService) ->
            $scope.energy = 100
            $scope.beta = 0.08
            $scope.visibility = 10
            $scope.counts = 10000
            $scope.low_energy_r = 0.5
            max_y = 3

            draw_graph = (v, n, r, beta, energy) ->
                min_x = bisect(
                    (a) -> comptonService.sigma_phi(a, beta, v, n) < max_y,
                    0.01,
                    0.99)
                min_x_no_compton = bisect(
                    (a) -> comptonService.sigma_phi_no_compton(a, v, n, r) < max_y,
                    0.01,
                    0.99)
                xs = d3.range(d3.round(min_x, 2), 0.99, 0.01)
                full_range = d3.range(d3.round(min_x_no_compton, 2), 0.99, 0.01)
                sigma_max = 2 * Math.PI / 5
                $scope.data = [
                    {
                        name: "Compton model"
                        values: xs.map (x) ->
                            [x, comptonService.sigma_phi(x, beta, v, n)]
                    },
                    {
                        name: "Constant log ratio = 0.5"
                        values: full_range.map (x) ->
                            [x, comptonService.sigma_phi_no_compton(x, v, n, r)]
                    },
                    {
                        name: "Constant log ratio = 2.0"
                        values: full_range.map (x) ->
                            [x, comptonService.sigma_phi_no_compton(x, v, n, 2)]
                    },
                    {
                        name: "Rose threshold"
                        values: [[0, sigma_max], [1, sigma_max]]
                    }
                ]
                $scope.graph = d3.chart.line()
                    .x_title "transmission"
                    .y_title "differential phase noise"
                $scope.graph
                    .y_scale()
                    .domain [0, 3]
                $scope.minimum_transmission = bisect(
                    (a) -> comptonService.sigma_phi(a, beta, v, n) < sigma_max,
                    0.01,
                    0.99)
                $scope.minimum_transmission_05 = bisect(
                    (a) -> comptonService.sigma_phi_no_compton(a, v, n, r) < sigma_max,
                    0.01,
                    0.99)
                $scope.minimum_transmission_20 = bisect(
                    (a) -> comptonService.sigma_phi_no_compton(a, v, n, 2) < sigma_max,
                    0.01,
                    0.99)

            draw_graph(
                $scope.visibility / 100,
                $scope.counts,
                $scope.low_energy_r,
                $scope.beta,
                $scope.energy)

            $scope.$watchCollection "[visibility, counts, low_energy_r]", (new_values, old_values) ->
                draw_graph(
                    $scope.visibility / 100,
                    $scope.counts,
                    $scope.low_energy_r,
                    $scope.beta,
                    $scope.energy)

            $scope.$watchCollection "[energy, minimum_transmission, minimum_transmission_05, minimum_transmission_20]", (new_values, old_values) ->
                Table.success (raw_table) ->
                    $scope.table = thicknessCalculatorService.thickness_table(
                        raw_table,
                        $scope.energy,
                        $scope.minimum_transmission,
                        $scope.minimum_transmission_05,
                        $scope.minimum_transmission_20
                    )
    ]
