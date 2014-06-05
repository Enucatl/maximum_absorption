'use strict'

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
])

App.config([
  '$routeProvider'
  '$locationProvider'

($routeProvider, $locationProvider, config) ->

  $routeProvider

    .when('/', {templateUrl: '/partials/home.html'})
    .when('/dark_field_absorption', {templateUrl: '/partials/dark_field_absorption.html'})
    .when('/noise_absorption', {templateUrl: '/partials/noise_absorption.html'})
    .when('/maximum_thickness', {templateUrl: '/partials/maximum_thickness.html'})

    # Catch all
    .otherwise({redirectTo: '/'})

  # Without server side support html5 must be disabled.
  $locationProvider.html5Mode(false)
])
