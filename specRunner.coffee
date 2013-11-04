require.config({
    paths: {
        jquery: 'lib/jquery',
        'jasmine': 'lib/jasmine-1.3.1/jasmine',
        'jasmine-html': 'lib/jasmine-1.3.1/jasmine-html',
    },
    shim: {
        jasmine: {
            exports: 'jasmine'
        },
        'jasmine-html': {
            deps: ['jasmine'],
            exports: 'jasmine'
        }
    }
})

require(['jquery', 'jasmine-html'], ($, jasmine) ->

    jasmineEnv = jasmine.getEnv()
    jasmineEnv.updateInterval = 1500

    htmlReporter = new jasmine.HtmlReporter()

    jasmineEnv.addReporter(htmlReporter)

    jasmineEnv.specFilter = (spec) ->
      return htmlReporter.specFilter(spec)

    specs = []

    specs.push('spec/gamespec')
    specs.push('spec/playerspec')


    $(()->
      require(specs, (spec) ->
        jasmineEnv.execute()
      )
    )

)
