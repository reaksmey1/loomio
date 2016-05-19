angular.module('loomioApp').directive 'groupTheme', ->
  scope: {group: '=', homePage: '=', compact: '='}
  restrict: 'E'
  templateUrl: 'generated/components/group_page/group_theme/group_theme.html'
  replace: true
  controller: ($scope, Session, AbilityService, ModalService, CoverPhotoForm, LogoPhotoForm, LmoUrlService) ->

    $scope.logoStyle = ->
      { 'background-image': "url(#{LmoUrlService.srcFor($scope.group.logoUrl())})" }

    $scope.coverStyle = ->
      { 'background-image': "url(#{LmoUrlService.srcFor($scope.group.coverUrl())})", 'z-index': (-1 if $scope.compact) }

    $scope.isMember = ->
      Session.user().membershipFor($scope.group)?

    $scope.canUploadPhotos = ->
      $scope.homePage and AbilityService.canAdministerGroup($scope.group)

    $scope.openUploadCoverForm = ->
      ModalService.open CoverPhotoForm, group: => $scope.group

    $scope.openUploadLogoForm = ->
      ModalService.open LogoPhotoForm, group: => $scope.group

    $scope.themeHoverIn = ->
      $scope.themeHover = true

    $scope.themeHoverOut = ->
      $scope.themeHover = false

    $scope.logoHoverIn = ->
      $scope.logoHover = true

    $scope.logoHoverOut = ->
      $scope.logoHover = false
