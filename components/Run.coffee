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
  c.outPorts.add 'out',
    datatype: 'object'
  c.outPorts.add 'error',
    datatype: 'object'

  c.runner = null
  c.shutdown = ->
    return unless c.runner
    c.runner.stop ->
    c.runner = null

  noflo.helpers.WirePattern c,
    in: ['code', 'in']
    params: ['port']
    async: true
    forwardGroups: true
  , (data, groups, out, callback) ->
    options = data.options or {}
    unless c.runner
      c.runner = new jsjob.Runner c.params
      c.runner.start (err) ->
        return callback err if err
        c.runner.runJob data.code, data.in, options, (err, result, details) ->
          return callback err if err
          out.send result
          do callback
      return
    c.runner.runJob data.code, data.in, options, (err, result, details) ->
      return callback err if err
      out.send result
      do callback
