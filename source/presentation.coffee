module = angular.module("PresentationModule", [])

@PresentationController = ($scope, $location, keyboard) ->
  RIGHT_ARROW = 39
  LEFT_ARROW = 37
  keyboard.on RIGHT_ARROW, ->
    $scope.activeSlide++

  keyboard.on LEFT_ARROW, ->
    $scope.activeSlide--

  $scope.$watch "activeSlide", (value) ->
    if value is -1
      $location.url ""
    else $location.url "/slides/" + (value + 1)  if value > -1

  $scope.$watch (-> $location.url()), (value) ->
    match = /\/slides\/(\d+)/.exec(value)
    if match
      $scope.activeSlide = parseInt(match[1], 10) - 1
    else $scope.activeSlide = scope.totalSlides  if value is "/slides/end"

  $scope.isInsideDeck = ->
    not @isBefore() and not @isAfter()

  $scope.isBefore = ->
    $scope.activeSlide < 0

  $scope.isAfter = ->
    $scope.activeSlide >= $scope.totalSlides

module.service "keyboard", ($rootScope) ->
  @on = (keyCode, callback) ->
    $(window).keydown (e) ->
      $rootScope.$apply callback  if e.keyCode is keyCode

module.directive "deck", ->
  link = ($scope, element, attrs) ->
    restack = ->
      slides.each (i, slide) ->
        slide.style.zIndex = "auto"
        slide.style.zIndex = -i  if $(slide).hasClass("next")
    slides = element.find("slide")
    restack()
    $scope.total slides.length
    $scope.current -1
    $scope.$watch "current()", (value) ->
      slides.each (i, slide) ->
        $(slide).removeClass "previous current next"
        if i < value
          $(slide).addClass "previous"
        else if i is value
          $(slide).addClass "current"
        else
          $(slide).addClass "next"

      if value < -1 or isNaN(value)
        $scope.current -1
      else if value > slides.length
        $scope.current slides.length
      else
        restack()
  restrict: "E"
  scope:
    current: "accessor"
    total: "accessor"

  link: link

module.directive "slideCode", ->
  (scope, element, attrs) ->
    value = attrs.slideCode
    element.addClass "brush: js; toolbar: false;"
    element.addClass "haml-script: true;"  unless value is "js"
    element.attr "ng-non-bindable", ""

module.directive "example", ($http) ->
  restrict: "E"
  template: "<script type='syntaxhighlighter' slide-code ng-bind='raw'></script><iframe ng-src='{{compiled}}'></iframe>"
  scope: {}
  link: (scope, element, attrs) ->
    scope.source = "/#{attrs.name}.haml"
    scope.compiled = "/#{attrs.name}.html"
    $http.get(scope.source).success (data) ->
      scope.raw = data
