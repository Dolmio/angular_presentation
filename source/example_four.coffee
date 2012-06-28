# $http is a service, part of Angular
@MainController = ($scope, $http) ->
  $http.get("/posts.json").success (data) ->
    $scope.posts = data.posts

@CommentsController = ($scope, $http) ->
  $http.get("/comments_#{$scope.post.id}.json").success (data) ->
    $scope.comments = data.comments

  $scope.upboat = (comment) ->
    alert("You upvoted #{comment.the_douchebags_name}'s comment.")
  $scope.report = (comment) ->
    alert("#{comment.the_douchebags_name} got bit.")
