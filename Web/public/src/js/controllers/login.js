angular.module('SwagSwap')
.controller('LoginCtrl', function($scope, Auth) {
  console.log('LoginCtrl');
  $scope.login = function() {
    Auth.login({ email: $scope.email, password: $scope.password });
  };
  $scope.facebookLogin = function() {
    Auth.facebookLogin();
  };
});
