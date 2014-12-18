module.exports = function(grunt) {

  grunt.initConfig({

    // COPY TASKS ==============================================================
    copy: {
      main: {
        files: [{
          cwd: 'bower_components/',
          src: ['**/*'],
          dest: 'public/dist/lib/',
          expand: true
        }]
      }
    },
    // JS TASKS ================================================================
    jshint: {
      all: ['public/src/js/**/*.js']
    },

    uglify: {
      build: {
        files: {
          'public/dist/js/app.min.js': ['public/src/js/**/*.js', 'public/src/js/*.js']
        }
      }
    },

    // CSS TASKS ===============================================================
    sass: {
      dist: {
        files: {
          'public/dist/css/style.css': 'public/src/css/style.scss'
        }
      }
    },

    cssmin: {
      build: {
        files: {
          'public/dist/css/style.min.css': 'public/dist/css/style.css'
        }
      }
    },

    // COOL TASKS ==============================================================
    watch: {
      css: {
        files: ['public/src/css/**/*.scss'],
        tasks: ['sass', 'cssmin']
      },
      js: {
        files: ['public/src/js/**/*.js'],
        tasks: ['jshint', 'uglify']
      }
    },

    nodemon: {
      dev: {
        script: 'server.js'
      }
    },

    concurrent: {
      options: {
        logConcurrentOutput: true
      },
      tasks: ['nodemon', 'watch']
    }

  });

  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-sass');
  grunt.loadNpmTasks('grunt-contrib-cssmin');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-nodemon');
  grunt.loadNpmTasks('grunt-concurrent');
  grunt.loadNpmTasks('grunt-contrib-copy');

  grunt.registerTask('default', ['sass', 'cssmin', 'jshint', 'copy', 'uglify', 'concurrent']);

};
