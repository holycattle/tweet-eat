module = angular.module 'tamad.home', [
  'tamad.auth'
]

module.controller 'HomeCtrl', ($scope, CurrentUser) ->
  setHomeUrl = ->
    if CurrentUser.loggedIn()
      $scope.home_url = '/html/home_logged_in.html'
    else
      $scope.home_url = '/html/home_anon.html'

  $scope.$on 'login-changed', (event) ->
    setHomeUrl()

  setHomeUrl()


module.controller 'HomeLoggedInCtrl', ($scope, CurrentUser, $http, Errand) ->
  $scope.user = CurrentUser.data
  $scope.errands = Errand.query()
  $scope.run = (errand) ->
    console.log "you chose to run errand:", errand
    $http.post("/api/errands/#{errand.id}/apply").success (response) ->
      console.log "success", response
    .error (response) ->
      console.log "didn't finish run successfully", response

module.controller 'HomeAnonCtrl', ($scope, Errand) ->
  $scope.errands = Errand.query()
