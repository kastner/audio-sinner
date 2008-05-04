$:.unshift File.dirname(__FILE__) + '/sinatra/lib'
require 'rubygems'
require 'sinatra'
require 'aws/s3'

# set utf-8 for outgoing
before do
  header "Content-Type" => "text/html; charset=utf-8"
end

get "/" do
  erb "hi!"
end