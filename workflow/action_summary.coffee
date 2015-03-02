q = require 'q'
qx = require 'qx'
http = require 'q-io/http'
_ = require 'lodash'
querystring = require 'querystring'
Table = require('cli-table')

module.exports =
  summary: (context) ->
    console.log ' --- Executing step ' + "Summary".green
    
    bodyObj = 
      cobSessionToken: context.sessionToken
      userSessionToken: context.userToken

    body = querystring.stringify bodyObj
    console.log body.italic.gray
    http.request 
        url: context.baseUrl + context.eventUrl.summary
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
          _.forEach jsonData, (item) ->
            console.log "#{item.itemDisplayName}".green.bold + "(#{item.contentServiceInfo.containerInfo.containerName})".gray + ", created #{item.refreshInfo.itemCreateDate}"
            dateStr = (date) ->
              (new Date(date * 1000)).toString()
            console.log "Updated: " + (dateStr item.refreshInfo.lastUpdatedTime).bold + ", Status/Action: " + "#{item.refreshInfo.itemAccessStatus.name} / #{item.refreshInfo.userActionRequiredType.name}".bold
            
            console.log 'Accounts:' 
            
            values = _.map item.itemData.accounts, (acc) ->
              avail = if acc.availableBalance then acc.availableBalance.amount else acc.availableCredit.amount
              owed = if acc.runningBalance then acc.runningBalance.amount else 0
              [acc.accountDisplayName.defaultNormalAccountName, acc.accountName, avail, owed]
            table = new Table({head: ['Name', 'Type', 'Available', 'Owed']})
            table.push.apply table, values
            console.log(table.toString())
        