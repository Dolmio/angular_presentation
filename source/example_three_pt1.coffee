# using @ to make it global
# $scope is your shared namespace with the HTML
# $http is a service, part of Angular
@MainController = ($scope, $http) ->
  $http.get("/posts.json").success (data) ->
    $scope.posts = data.posts
