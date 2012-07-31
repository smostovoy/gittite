Gittite
============
EM server for deploying all branches. Supports after hooks.

Installation
============

###1. checkout

     git clone git://github.com/granify/gittite.git

###2. Run bundler
      cd gittite
      bundle install

###3. Run server

      bundle exec ruby gittite.rb

Configuration
=============
###1. Set deploy path in config/gittite.rb

###2. Create file in <your project>/config/gittite.rb with something like:
```ruby
#Current dir is your project root path
run 'bundle install'
run 'touch ./tmp/restart.txt'
```
Use method 'run' to execute system command. This code will be executed after updating code.

###3. Set webhook in GitHub. Go to admin/service hooks/webhooks  to add server address

