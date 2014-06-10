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
        $scope.visibility = 0.1
        $scope.counts = 10000
        $scope.beta = 0.08
        $scope.low_energy_r = 0.5

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
                        t: -Math.log($scope.minimum_transmission) / mu
                        t_no_compton: -Math.log($scope.minimum_transmission_no_compton) / mu
                    }
])
