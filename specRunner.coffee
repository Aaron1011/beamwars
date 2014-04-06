require.config({
    baseUrl: './src'
    paths: {
        jquery: '../lib/jquery',
        'jasmine': '../lib/jasmine-2.0.0/jasmine',
        'jasmine-html': '../lib/jasmine-2.0.0/jasmine-html',
        'boot': '../lib/jasmine-2.0.0/boot',
        fabric: '../lib/fabric'
    },

    shim: {
        jasmine: {
            exports: 'window.jasmineRequire'
        },
        'jasmine-html': {
            deps: ['jasmine'],
            exports: 'window.jasmineRequire'
        },
        'boot': {
            deps: ['jasmine', 'jasmine-html'],
            exports: 'window.jasmineRequire'
        }
      }
    }
)

require(['jquery', 'boot'], ($) ->
    #jasmineEnv = jasmine.getEnv()
    #jasmineEnv.updateInterval = 1000

    #htmlReporter = new jasmine.HtmlReporter()

    #jasmineEnv.addReporter(htmlReporter)

    #jasmineEnv.specFilter = (spec) ->
    #  return htmlReporter.specFilter(spec)

    specs = []

    specs.push('../spec/gamespec')
    specs.push('../spec/playerspec')

    require(specs, ->
      window.onload()
    )


    #$(()->
    #  require(specs, (spec) ->
    #    jasmineEnv.execute()
    #  )
    #)

)
