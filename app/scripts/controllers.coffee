'use strict'

### Controllers ###

angular.module('app.controllers', [])

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

.controller('MaximumThicknessCtrl', [
    '$scope'
    '$http'

    ($scope, $http) ->
        $scope.energy = 100
        $scope.visibility = 10
        $scope.counts = 10000
        $scope.beta = 0.08
        $scope.low_energy_r = 0.5
        $scope.minimum_transmission = 0.4
        $scope.minimum_transmission_no_compton = 0.1

        $scope.update_table = (min_tr, min_tr_no_compton) ->
            $http.get "nist.data.json"
                .success (data) ->
                    $scope.table = data.map (element) ->
                        array = element.table.split(/\s+/).map(parseFloat)
                        rows = []
                        while array.length > 0
                            rows.push array.splice 0, 3
                        chosen_row = rows.filter (d) -> d[0] == $scope.energy * 1e-3
                        chosen_row = chosen_row[0]
                        mu = chosen_row[1] * element.density
                        {
                            name: element.name
                            t: -Math.log(min_tr) / mu
                            t_no_compton: -Math.log(min_tr_no_compton) / mu
                        }
        $scope.update_table()

        $scope.watch "minimum_transmission", (minimum_transmission, old_value) ->
            $scope.minimum_transmission = minimum_transmission
            $scope.$apply ->
                $scope.table = $scope.update_table($scope.minimum_transmission, $scope.minimum_transmission_no_compton)
        $scope.watch "minimum_transmission_no_compton", (minimum_transmission_no_compton, old_value) ->
            $scope.minimum_transmission_no_compton = minimum_transmission_no_compton
            $scope.$apply ->
                $scope.table = $scope.update_table($scope.minimum_transmission, $scope.minimum_transmission_no_compton)
])
