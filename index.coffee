require 'colors'
program = require 'commander'
workflow = new (require('events').EventEmitter)();

# Workflow
cobrandLogin = require './workflow/cobrand_login.coffee'
workflow.on 'cbLogin', cobrandLogin.cbLogin

program
  .version '0.0.1' 
  .option('-u, --cobranduser [User]', 'Cobrand User Name')
  .option('-p, --cobrandpwd [Password]', 'Cobrand Password')
  .parse(process.argv);

if not program.cobranduser or program.cobranduser.length == 0
  console.log 'You should specify user name using --cobranduser [User]'.red.bold
  process.exit 1

if not program.cobrandpwd or program.cobrandpwd.length == 0
  console.log 'You should specify password using --cobrandpwd [Password]'.red.bold
  process.exit 2

console.log 'Running sample for ' + "#{program.cobranduser}".green

context = 
  baseUrl: 'https://rest.developer.yodlee.com/services/srest/restserver/v1.0'
  eventUrl:
    coLogin: '/authenticate/coblogin'
  cbLogin: program.cobranduser
  cbPassword: program.cobrandpwd

workflow.emit 'cbLogin', context

