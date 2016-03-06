module.exports = ->
  # Project configuration
  @initConfig
    pkg: @file.readJSON 'package.json'

    # Updating the package manifest files
    noflo_manifest:
      update:
        files:
          'package.json': ['graphs/*', 'components/*']

    # BDD tests on Node.js
    mochaTest:
      nodejs:
        src: ['spec/*.coffee']
        options:
          reporter: 'spec'
          require: 'coffee-script/register'

    # Coding standards
    coffeelint:
      components:
        files:
          src: ['components/*.coffee']
        options:
          max_line_length:
            value: 80
            level: 'warn'

    connect:
      fixtures:
        options:
          port: 8090
          base: 'spec/fixtures'

  # Grunt plugins used for building
  @loadNpmTasks 'grunt-noflo-manifest'

  # Grunt plugins used for testing
  @loadNpmTasks 'grunt-mocha-test'
  @loadNpmTasks 'grunt-coffeelint'
  @loadNpmTasks 'grunt-contrib-connect'

  # Our local tasks
  @registerTask 'build', ['noflo_manifest']
  @registerTask 'test', ['coffeelint', 'build', 'connect', 'mochaTest']
  @registerTask 'default', ['test']
