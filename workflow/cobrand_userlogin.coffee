workflow = new (require('events').EventEmitter)();
q = require 'q'
qx = require 'qx'
http = require 'q-io/http'
querystring = require 'querystring'

module.exports =
  cbUserLogin: (context) ->
    console.log ' --- Executing step ' + "Cobrand User Login".green
    
    bodyObj = 
      login: context.uLogin
      password: context.uPassword
      cobSessionToken: context.sessionToken
    body = querystring.stringify bodyObj
    console.log body.italic.gray
    http.request 
        url: context.baseUrl + context.eventUrl.uLogin
        method: 'POST'
        headers: {"Content-Type": "application/x-www-form-urlencoded", "Content-Length":body.length}
        body: [body]
      .then (response) ->
        response.body.read().then (data) ->
          console.log data.toString('utf8');
          jsonData = JSON.parse(data)
          if not jsonData or not jsonData.userContext
            console.log 'Unable to get user token'.red.bold
          userToken = jsonData.userContext.conversationCredentials.sessionToken
          context.userToken = userToken
          console.log "Got user token "+ "#{userToken}".cyan
          context.workflow.emit context.action, context