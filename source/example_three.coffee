# using @ is shorthand in coffee for 'this.' which in this case is window
# $scope is your shared namespace with the HTML
window.HeaderController = ($scope) ->
  $scope.links = [{title: "Home", href: "/"},
                  {title: "Search", href: "/search"}]

@ContentController = ($scope) ->
  $scope.links = "Not the headers links, no sir."
