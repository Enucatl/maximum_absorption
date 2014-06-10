'use strict'

bisect = (predicate, low, high, tol=1e-6) ->
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


# Declare app level module which depends on filters, and services
App = angular.module('app', [
  'ngCookies'
  'ngResource'
  'ngRoute'
  'app.controllers'
  'app.directives'
  'app.filters'
  'app.services'
  'partials'
  'glider'
])

App.config([
  '$routeProvider'
  '$locationProvider'

($routeProvider, $locationProvider, config) ->

  $routeProvider

    .when('/home', {templateUrl: '/partials/home.html'})
    .when('/dark_field_absorption', {templateUrl: '/partials/dark_field_absorption.html'})
    .when('/noise_absorption', {templateUrl: '/partials/noise_absorption.html'})
    .when('/maximum_thickness', {templateUrl: '/partials/maximum_thickness.html'})

    # Catch all
    .otherwise({redirectTo: '/home'})

  # Without server side support html5 must be disabled.
  $locationProvider.html5Mode(false)
])
