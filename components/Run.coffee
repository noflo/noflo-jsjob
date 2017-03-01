noflo = require 'noflo'
jsjob = require 'jsjob'

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Execute JavaScript in a sandbox'
  c.icon = 'cogs'

  c.inPorts.add 'code',
    datatype: 'string'
    required: true
    description: 'URL to the JavaScript code to run'
  c.inPorts.add 'in',
    datatype: 'object'
    required: true
    description: 'Input to pass to the JavaScript code'
  c.inPorts.add 'port',
    datatype: 'integer'
    description: 'Port number for running the HTTP server used in solving'
    required: true
    default: 8088
    control: true
  c.outPorts.add 'out',
    datatype: 'object'
  c.outPorts.add 'error',
    datatype: 'object'

  c.runner = null
  c.shutdown = ->
    return unless c.runner
    c.runner.stop ->
    c.runner = null

  c.process (input, output) ->
    return unless input.hasData 'code', 'in'
    [code, data, port] = input.getData 'code', 'in', 'port'

    options = {}
    unless c.runner
      c.runner = new jsjob.Runner
        port: parseInt port
      c.runner.start (err) ->
        return output.sendDone err if err
        c.runner.runJob code, data, options, (err, result, details) ->
          return output.sendDone err if err
          output.sendDone
            out: result
      return
    c.runner.runJob code, data, options, (err, result, details) ->
      return output.sendDone err if err
      output.sendDone
        out: result
