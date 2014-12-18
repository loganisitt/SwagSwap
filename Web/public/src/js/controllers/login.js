angular.module('Bazaaru')
.controller('LoginCtrl', function($scope, Auth) {
  console.log('LoginCtrl');
  $scope.login = function() {
    console.log('login');
    Auth.login({ email: $scope.email, password: $scope.password });
  };
  $scope.facebookLogin = function() {
    console.log('facebookLogin');
    Auth.facebookLogin();
  };
});
