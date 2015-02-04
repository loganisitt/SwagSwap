angular.module('SwagSwap')
.controller('NavbarCtrl', function($scope, Auth) {
  $scope.logout = function() {
    Auth.logout();
  };
});
