q = require 'q'
qx = require 'qx'
http = require 'q-io/http'
_ = require 'lodash'
querystring = require 'querystring'
Table = require('cli-table')

module.exports =
  search: (context) ->
    console.log ' --- Executing step ' + "Search".green
    
    bodyObj = 
      cobSessionToken: context.sessionToken
      userSessionToken: context.userToken
      siteSearchString: context.actionData

    body = querystring.stringify bodyObj
    console.log body.italic.gray
    http.request 
        url: context.baseUrl + context.eventUrl.search
        method: 'POST'
        headers: {"Content-Type": "application/x-www-form-urlencoded", "Content-Length":body.length}
        body: [body]
      .then (response) ->
        response.body.read().then (data) ->
          console.log data.toString('utf8');
          jsonData = JSON.parse(data)
          if not jsonData or not _.isArray(jsonData)
            console.log "Search for sites failed".red
            return
          console.log 'Found ' + "#{jsonData.length}".yellow + " sites"
          values = _.map jsonData, (item) ->
            [item.siteId, item.defaultDisplayName, item.baseUrl]
          table = new Table({head: ['SiteId', 'Name', 'URL']})
          table.push.apply table, values
          console.log(table.toString())