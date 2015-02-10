angular.module('SwagSwap').factory('Users', ['$http', function($http) {
  return $http.get('/api/users');
}]);
