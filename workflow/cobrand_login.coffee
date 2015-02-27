workflow = new (require('events').EventEmitter)();
q = require 'q'
qx = require 'qx'
http = require 'q-io/http'
querystring = require 'querystring'

module.exports =
  cbLogin: (context) ->
    console.log ' --- Executing step ' + "Cobrand Login".green
    
    bodyObj = 
      cobrandLogin: context.cbLogin
      cobrandPassword: context.cbPassword
    body = querystring.stringify bodyObj

    http.request 
        url: context.baseUrl + context.eventUrl.coLogin
        method: 'POST'
        headers: {"Content-Type": "application/x-www-form-urlencoded", "Content-Length":body.length}
        body: [body]
      .then (response) ->
        response.body.read().then (data) ->
          console.log data.toString('utf8');