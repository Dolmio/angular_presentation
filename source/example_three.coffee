# using @ to make it global
# $scope is your shared namespace with the HTML
# $http is a service, part of Angular
@MainController = ($scope, $http) ->
  $http.get("/posts.json").success (data) ->
    $scope.posts = data.posts

@CommentsController = ($scope, $http) ->
  $http.get("/comments_#{$scope.post.id}.json").success (data) ->
    $scope.comments = data.comments

  $scope.upboat = ->
    console.log
