module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    uglify: {
      options: {
        banner: '/*! Pick-a-Color v<%= pkg.version %> | Copyright 2013 Lauren Sperber and Broadstreet Ads https://github.com/lauren/pick-a-color/blob/master/LICENSE | <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
      },
      my_target: {
        files: {
          'build/<%= pkg.version %>/js/<%= pkg.name %>-<%= pkg.version %>.min.js': ['src/js/<%= pkg.name %>.js'],
          'docs/build/js/<%= pkg.name %>.min.js': ['src/js/<%= pkg.name %>.js']
        }
      }    },
    less: {
      production: {
        options: {
          compress: true,
          paths: ["src/less/css"]
        },
        files: {
          "build/<%= pkg.version %>/css/<%= pkg.name %>-<%= pkg.version %>.min.css": "src/less/<%= pkg.name %>.less",
          "docs/build/css/<%= pkg.name %>.min.css": "src/less/<%= pkg.name %>.less"
        }
      }
    },
    watch: {
      js: {
        files: ['src/js/*.js', 'Gruntfile.js'],
        tasks: ['jshint', 'uglify'],
      },
      less: {
        files: ['src/less/*.less', 'src/less/bootstrap-src/*.less'],
        tasks: ['less'],
      }
    },
    jshint: {
      all: ['Gruntfile.js', 'src/*/*.js'],
      options: {
        laxbreak: true,
        force: true
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-less');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-jshint');

};