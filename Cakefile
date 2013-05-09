{exec} = require "child_process"

task "test", "run tests", ->
  exec "NODE_ENV=test
    ./node_modules/.bin/mocha
    --compilers coffee:coffee-script
    --reporter spec
    --colors
    test.coffee
  ", (err, output) ->
    throw err if err
    console.log output

