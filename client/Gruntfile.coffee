'use strict'

path = require 'path'

module.exports = (grunt) ->
  grunt.initConfig
    dist: 'public'

    coffee:
      all:
        expand: true
        cwd: 'source/'
        src: [
          'controllers/**/*.coffee',
          'services/**/*.coffee',
          'directives/**/*.coffee',
          'commons/**/*.coffee']
        dest: '<%= dist %>'
        ext: '.js'

      options:
        bare: true
        sourceMap: true

    mapcat:
      all:
        src: [
          '<%= dist %>/controllers/**/index.js.map'
          '<%= dist %>/controllers/**/*.js.map'
        ]
        dest: '<%= dist %>/scripts.js'

      options:
        oldRoot: 'source/controllers/'
        newRoot: 'src'

    jade:
      options:
        pretty: true
      all:
        expand: true
        cwd: 'source/'
        src: ['views/**/*.jade']
        dest: '<%= dist %>'
        ext: '.html'


    html2js:
      all:
        src: '<%= dist %>/views/**/*.html'
        dest: '<%= dist %>/templates.js'

      options:
        base: '<%= dist %>'
        module: 'wpApp.templates'
        rename: (name) ->
          name.replace /\.html$/, '.jade'
        indentString: '\t'
        quoteChar: "'"

    concat:
      dist:
        files: [
          '<%= dist %>/scripts.js': [
            #the order is very important
            '<%= dist %>/controllers/**/index.js'
            '<%= dist %>/controllers/**/*.js'
            '<%= dist %>/services/**/*.js'
            '<%= dist %>/commons/**/*.js'
            '<%= dist %>/directives/**/*.js'
          ]
        ]

    copy:
      bower:
        files: [
          expand: true
          cwd: 'source/bower_components/'
          src: '**/*'
          dest: '<%= dist %>/bower_components/'
        ]
      libs:
        files: [
          expand: true
          cwd: 'source/libs/'
          src: '**/*'
          dest: '<%= dist %>/libs/'
        ]
      assets:
        files: [
          expand: true
          cwd: 'source/assets/'
          src: '**/*'
          dest: '<%= dist %>/assets/'
        ]

    watch:
      coffee:
        files: ['source/**/*.coffee']
        tasks: [
          'coffee'
          'concat'
        ]
        # options:
        #   spawn: false

      jade:
        files: ['source/**/*.jade']
        tasks: [
          'jade:all'
          'html2js'
        ]
        # options:
        #   spawn: false

      recess:
        files: 'source/contents/**/*.less'
        tasks: [
          'recess'
        ]
        # options:
        #   spawn: false

      options:
        dateFormat: (time) ->
          date = new Date().toLocaleTimeString()
          grunt.log.writeln "Completed in #{time}s at #{date}".cyan
          grunt.log.write 'Waiting... '

    nodemon:
      local:
        script: 'source/server.coffee'

    concurrent:
      options:
        limit: 4

      local:
        tasks: [
          'nodemon:local'
          'watch'
        ]
        options:
          logConcurrentOutput: true

    clean:
      build: ['<%= dist %>']

  targetFiles = {}
  # Compile only changed files
  grunt.event.on 'watch', (action, filepath, target) ->
    return if target is 'index'
    targetFiles[target] ?= []
    targetFiles[target].push filepath
    onChange()

  onChange = grunt.util._.debounce ->
    for target, files of targetFiles
      grunt.config [target, 'all', 'src'], files
    targetFiles = {}
  , 200

  grunt.file.expand("./node_modules/grunt-*/tasks").forEach grunt.loadTasks

  grunt.registerTask 'default', [
    'clean'
    'coffee'
    'concat'
    'jade'
    'html2js'
    'copy'
    'watch'
    # 'concurrent:local'
  ]
