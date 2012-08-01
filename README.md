Gittite
============
Simple EM server for deploying GitHub projects with all branches with each push to repository.
It's perfect for testing branches before merging them to master so it  was not designed for production server.
It does not store previous releases.
It supports after hooks.

Installation
============

###1. Checkout code on your testing server

     git clone git://github.com/granify/gittite.git

###2. Run bundler
      cd gittite
      bundle install

###3. Run server

      bundle exec gittite.rb -sv -p 9000 -e prod

Configuration
=============
###1. Set deploy path in config/gittite.rb
```ruby
config['deploy_path'] = '/home/deploy/'
```

###2. After deploy hook
Create file {your project}/config/gittite.rb with something like:
```ruby
#Current dir is your project root path
run 'bundle install'
run 'touch ./tmp/restart.txt'
```
Use method 'run' to execute system command. This code will be executed after updating code.

###3. Set webhook in GitHub.
Go to Admin/ Service hooks/ Webhook URLs  to add server address

