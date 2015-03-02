require 'colors'
program = require 'commander'
workflow = new (require('events').EventEmitter)();
Q = require('q');

# Workflow
workflow.on 'cbLogin', require('./workflow/cobrand_login.coffee').cbLogin
workflow.on 'cbUserLogin', require('./workflow/cobrand_userlogin.coffee').cbUserLogin
workflow.on 'search', require('./workflow/action_search.coffee').search
workflow.on 'summary', require('./workflow/action_summary.coffee').summary

program
  .version '0.0.1' 
  .option('-u, --cobranduser [User]', 'Cobrand User Name')
  .option('-p, --cobrandpwd [Password]', 'Cobrand Password')
  .option('-l, --user [User]', 'User Name')
  .option('-s, --pwd [Password]', 'Password')
  .option('-a, --action [search|summary]', 'Action to perform against this user')
  .option('-d, --data [data]', 'Action data')
  .parse(process.argv);

if not program.cobranduser or program.cobranduser.length == 0
  console.log 'You should specify user name using --cobranduser [User]'.red.bold
  process.exit 1

if not program.cobrandpwd or program.cobrandpwd.length == 0
  console.log 'You should specify password using --cobrandpwd [Password]'.red.bold
  process.exit 2

console.log 'Running sample for ' + "#{program.cobranduser}".green


context =
  workflow: workflow
  baseUrl: 'https://rest.developer.yodlee.com/services/srest/restserver/v1.0'
  eventUrl:
    coLogin: '/authenticate/coblogin'
    uLogin: '/authenticate/login'
    search: '/jsonsdk/SiteTraversal/searchSite'
    summary: '/jsonsdk/DataService/getItemSummaries'
  cbLogin: program.cobranduser
  cbPassword: program.cobrandpwd
  uLogin: program.user
  uPassword: program.pwd
  action: program.action
  actionData: program.data

workflow.emit 'cbLogin', context

