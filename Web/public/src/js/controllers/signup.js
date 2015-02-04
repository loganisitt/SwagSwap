angular.module('SwagSwap')
.controller('SignupCtrl', ['$scope', 'Auth', function($scope, Auth) {
  $scope.signup = function() {
    Auth.signup({
      email: $scope.email,
      password: $scope.password
    });
  };
}]);
