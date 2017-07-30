module.exports = (grunt) ->

    require('es6-promise').polyfill()

    # Project configuration
    grunt.initConfig({

        pkg: grunt.file.readJSON('package.json')

        coffee:
            options:
                join: true

            build:
                files:
                    'src/tmp/content-flow.js': [
                        'src/scripts/namespace.coffee'

                    ]

            sandbox:
                files:
                    'sandbox/sandbox.js': [
                        'src/sandbox/sandbox.coffee'
                        ]

        sass:
            options:
                banner: '/*! <%= pkg.name %> v<%= pkg.version %> by <%= pkg.author.name %> <<%= pkg.author.email %>> (<%= pkg.author.url %>) */'
                sourcemap: 'none'

            build:
                files:
                    'build/content-flow.min.css':
                        'src/styles/content-flow.scss'

            sandbox:
                files:
                    'sandbox/sandbox.css': 'src/sandbox/sandbox.scss'

        cssnano:
            options:
                sourcemap: false

            build:
                files:
                    'build/content-flow.min.css':
                        'build/content-flow.min.css'

        uglify:
            options:
                banner: '/*! <%= pkg.name %> v<%= pkg.version %> by <%= pkg.author.name %> <<%= pkg.author.email %>> (<%= pkg.author.url %>) */\n'
                mangle: true

            build:
                src: 'build/content-flow.js'
                dest: 'build/content-flow.min.js'

        concat:
            build:
                src: [
                    'node_modules/ContentTools/build/content-tools.js',
                    'src/tmp/content-flow.js'
                ]
                dest: 'build/content-flow.js'

        clean:
            build: ['src/tmp']

        watch:
            build:
                files: [
                    'src/scripts/**/*.coffee',
                    'src/styles/**/*.scss'
                    ]
                tasks: ['build']

            sandbox:
                files: [
                    'src/sandbox/*.coffee',
                    'src/sandbox/*.scss'
                    ]
                tasks: ['sandbox']
    })

    # Plug-ins
    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-concat'
    grunt.loadNpmTasks 'grunt-contrib-jasmine'
    grunt.loadNpmTasks 'grunt-contrib-sass'
    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-cssnano'

    # Tasks
    grunt.registerTask 'build', [
        'coffee:build'
        'sass:build'
        'cssnano:build'
        'concat:build'
        'uglify:build'
        'clean:build'
    ]

    grunt.registerTask 'sandbox', [
        'coffee:sandbox'
        'sass:sandbox'
    ]

    grunt.registerTask 'watch-build', ['watch:build']
    grunt.registerTask 'watch-sandbox', ['watch:sandbox']
