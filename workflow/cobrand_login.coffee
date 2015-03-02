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
    console.log body.italic.gray
    http.request 
        url: context.baseUrl + context.eventUrl.coLogin
        method: 'POST'
        headers: {"Content-Type": "application/x-www-form-urlencoded", "Content-Length":body.length}
        body: [body]
      .then (response) ->
        response.body.read().then (data) ->
          console.log data.toString('utf8');
          jsonData = JSON.parse(data)
          if not jsonData or not jsonData.cobrandConversationCredentials
            console.log 'Unable to get session token'.red.bold
          sessionToken = jsonData.cobrandConversationCredentials.sessionToken
          console.log "Got session token "+ "#{sessionToken}".cyan
          context.sessionToken = sessionToken
          context.workflow.emit 'cbUserLogin', context