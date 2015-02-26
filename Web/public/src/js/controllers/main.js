angular.module('SwagSwap')
	.controller('MainCtrl', ['$scope', 'Auth', function($scope, Auth) {
		$scope.firstname = Auth.user();

	}]);