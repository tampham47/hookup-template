'use strict'

# require order is important
app = angular.module 'wpApp', [
  'ui.router'
  'ngAnimate'
  'winjs'
	'wpApp.templates'
	'wpApp.home'
]

app.constant 'homeStateName', 'homeState'

app.run (navigationService) ->
  navigationService.goHome()
  return

app.animation '.turnstile-animation', ->
  enter: (element, done) ->
    WinJS.UI.Animation.turnstileForwardIn(element[0]).then done
    return
  leave: (element, done) ->
    done()
    return

initNavigation = ->
  NavigationService = ($q, $state, adapterSvc, homeStateName) ->
    WinJS.Navigation.addEventListener "navigating", (args) ->
      targetState = args.detail.location
      angularPromise = $state.go(targetState, args.detail.state)
      args.detail.setPromise adapterSvc.toWinJSPromise(angularPromise)
      return

    @goHome = ->
      adapterSvc.toAngularPromise WinJS.Navigation.navigate(homeStateName)

    @navigateTo = (view, initialState) ->
      adapterSvc.toAngularPromise WinJS.Navigation.navigate(view, initialState)

    @goBack = ->
      adapterSvc.toAngularPromise WinJS.Navigation.back()

    @goForward = ->
      adapterSvc.toAngularPromise WinJS.Navigation.forward()
    return
  app.service "navigationService", NavigationService
  return
initNavigation()

app.service 'adapterService', ($q) ->
  toAngularPromise: (winjsPromise) ->
    deferred = $q.defer()
    winjsPromise.then (value) ->
      deferred.resolve(value); return
    , (err) ->
      deferred.reject(err); return
    , (value) ->
      deferred.notify(value); return
    return deferred.promise

  toWinJSPromise: (angularPromise) ->
    signal = new WinJS._Signal()
    angularPromise
    .then (value) ->
      signal.complete(value); return
    , (err) ->
      signal.error(err); return
    , (value) ->
      signal.progress(value);return
    return signal.promise
