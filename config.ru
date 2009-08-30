require 'rubygems'
require 'sinatra/lib/sinatra.rb'
require "../awskeys.rb"

set :run, false
# set :env, :production

require 'mp3.rb'
run Sinatra::Application
