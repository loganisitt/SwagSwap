angular.module('SwagSwap')
  .factory('Auth', ['$http', '$location', '$rootScope', '$cookieStore', '$alert', '$window',
    function($http, $location, $rootScope, $cookieStore, $alert, $window) {
      $rootScope.currentUser = $cookieStore.get('user');
      $cookieStore.remove('user');

      return {
        user: function() {
          return $rootScope.currentUser;
        },
        facebookLogin: function() {
          return $http.get('/auth/facebook')
            .success(function(data) {
              $rootScope.currentUser = data;
              $location.path('/');

              $alert({
                title: 'Cheers!',
                content: 'You have successfully logged in.',
                placement: 'top-right',
                type: 'success',
                duration: 3
              });
            })
            .error(function() {
              $alert({
                title: 'Error!',
                content: 'Invalid username or password.',
                placement: 'top-right',
                type: 'danger',
                duration: 3
              });
            });
        },
        login: function(user) {
          return $http.post('/auth/login', user)
            .success(function(data) {
              $rootScope.currentUser = data;
              $location.path('/');

              $alert({
                title: 'Cheers!',
                content: 'You have successfully logged in.',
                placement: 'top-right',
                type: 'success',
                duration: 3
              });
            })
            .error(function() {
              $alert({
                title: 'Error!',
                content: 'Invalid username or password.',
                placement: 'top-right',
                type: 'danger',
                duration: 3
              });
            });
        },
        signup: function(user) {
          return $http.post('/auth/signup', user)
            .success(function() {
              $location.path('/login');

              $alert({
                title: 'Congratulations!',
                content: 'Your account has been created.',
                placement: 'top-right',
                type: 'success',
                duration: 3
              });
            })
            .error(function(response) {
              $alert({
                title: 'Error!',
                content: response.data,
                placement: 'top-right',
                type: 'danger',
                duration: 3
              });
            });
        },
        logout: function() {
          return $http.get('/auth/logout').success(function() {
            $rootScope.currentUser = null;
            $cookieStore.remove('user');
            $alert({
              content: 'You have been logged out.',
              placement: 'top-right',
              type: 'info',
              duration: 3
            });
          });
        }
      };
    }
  ]);