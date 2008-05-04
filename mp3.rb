$:.unshift File.dirname(__FILE__) + '/sinatra/lib'
require 'rubygems'
require 'sinatra'
require 'aws/s3'
require 'memcache'
require 'sha1'
require 'open-uri'

require 'ruby-debug'

include AWS::S3

before do
  # always send utf-8
  header "Content-Type" => "text/html; charset=utf-8"
  
  # set css body id
  @body_id = "home"
  
  # set up a cache object
  CACHE = MemCache.new 'localhost:11211', :namespace => 'my_namespace' unless Object.const_defined?("CACHE")
  
  # the bucket to upload to
  BUCKET = "mp3s.metaatem.net" unless Object.const_defined?("BUCKET")
  
  # set up s3
  AWS::S3::Base.establish_connection!(
    :access_key_id => ENV["AMAZON_ACCESS_KEY_ID"],
    :secret_access_key => ENV["AMAZON_SECRET_ACCESS_KEY"]
  )
end

get "/" do
  @files = Bucket.find(BUCKET).objects.collect do |object|
    "<a href='http://#{BUCKET}/#{object.key.to_s}'>#{URI.unescape(object.metadata[:name].to_s)}</a>" 
  end.join("<br/>")
  
  erb :index
end

get "/fetch" do
  name = params[:key]
  url = CACHE[params[:key]]

  if S3Object.exists? name, BUCKET
    redirect "http://#{BUCKET}/#{name}"
    halt
  end
  
  remote_header = %x{curl -s -u #{ENV["EZNEWS_USER"]}:#{ENV["EZNEWS_PASS"]} --head "#{url}"}
    
  Thread.new do
    puts "In thread"
    bits = open(CACHE[params[:key]], :http_basic_authentication => [ENV["EZNEWS_USER"], ENV["EZNEWS_PASS"]])
    
    item = S3Object.store(name, bits, BUCKET, :access => :public_read, :content_type => remote_header[/Content-Type: ([^\n]*)/, 1], "x-amz-meta-name" => File.basename(url))
    puts "uploaded!"
  end
  
  redirect "/?send=true"
end

get "/search" do
  require 'hpricot'
  contents = eznews_contents(params[:q])
  p = Hpricot.XML(contents)
  @files = (p / "item link").map do |l| 
    link = l.innerHTML
    string = URI.unescape(File.basename(link))
    hash_key = SHA1.hexdigest(link)
    CACHE[hash_key] = link
    "<a href='/fetch?key=#{hash_key}'>#{string}</a>" 
  end.reverse.join "<br/>"
  
  erb :results
end

def eznews_contents(terms)
  url = "http://members.easynews.com/global4/search.html?gps=#{URI.escape(terms)}&fex=mp3&fty%5B%5D=AUDIO&s1=dsize&s1d=-&s2=dtime&s2d=-&s3=dsize&s3d=%2B&pby=20&pno=1&sS=5"
  open(url, :http_basic_authentication => [ENV["EZNEWS_USER"], ENV["EZNEWS_PASS"]]).read
end