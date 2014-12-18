angular.module('Bazaaru')
.controller('NavbarCtrl', function($scope, Auth) {
  $scope.logout = function() {
    Auth.logout();
  };
});
