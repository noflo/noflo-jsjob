fbpspec = require 'fbp-spec'

nodeRuntime =
  label: "NoFlo node.js"
  description: ""
  type: "noflo"
  protocol: "websocket"
  secret: 'notasecret'
  address: "ws://localhost:3333"
  id: "7807f4d8-63e0-4a89-a577-2770c14f8106"
  command: './node_modules/.bin/noflo-nodejs  --catch-exceptions=true --secret notasecret --port=3333 --host=localhost --capture-output=true --debug=false'

fbpspec.mocha.run nodeRuntime, './spec', { fixturetimeout: 10000 }
