'use strict'

angular.module('wpApp.home', [])
.config ($stateProvider) ->
  $stateProvider.state "homeState",
    url: "/todoList"
    templateUrl: "/views/index.jade"
    controller: "HomeCtrl"
  return

.controller 'HomeCtrl', ($scope, $location) ->
  $scope.title = 'Hello world!'
