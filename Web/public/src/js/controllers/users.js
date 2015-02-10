angular.module('SwagSwap').controller('UsersCtrl', ['$scope', 'Users', function($scope, Users) {
  Users.success(function(data) {
    $scope.users = data;
  }).error(function(data, status) {
    console.log(data, status);
    $scope.users = [];
  });
}]);
