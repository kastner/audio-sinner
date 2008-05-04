$:.unshift File.dirname(__FILE__) + '/sinatra/lib'
require 'rubygems'
require 'sinatra'
require 'aws/s3'
require 'memcache'
require 'sha1'
require 'open-uri'

require 'ruby-debug'

# set utf-8 for outgoing
before do
  header "Content-Type" => "text/html; charset=utf-8"
  @body_id = "home"
  CACHE = MemCache.new 'localhost:11211', :namespace => 'my_namespace' unless Object.const_defined?("CACHE")
end

get "/" do
  @files = ["James - Laid.mp3", "The Bad Plus - Iron Man.mp3"]
  @files = []
  
  erb :index
end

get "/fetch" do
  url = CACHE[params[:key]]
  
  # set headers
  remote_header = %x{curl -s -u #{ENV["EZNEWS_USER"]}:#{ENV["EZNEWS_PASS"]} --head "#{url}"}
  %w|Last-Modified ETag Accept-Ranges Content-Length Content-Type|.each do |h|
    header h => remote_header[/#{h}: ([^\n]*)/, 1]
  end

  if @request.env.has_key?("HTTP_RANGE")
    bytes = @request.env["HTTP_RANGE"].gsub(/bytes=/,'')
    from, to = bytes.split(/-/)
    puts "from is #{from} and to is #{to}"
    puts "bytes = #{bytes}"
    header "Content-Range" => "bytes #{bytes}/#{header["Content-Length"]}"
    header "Content-Length" => (to.to_i - from.to_i + 1).to_s
    header "Connection" => "keep-alive"
    status 206
    out = %x{curl -s -r#{bytes} --raw -u #{ENV["EZNEWS_USER"]}:#{ENV["EZNEWS_PASS"]} "#{url}"}
  elsif @request.env["REQUEST_METHOD"] == "HEAD"
    out = ""
  else
    out = %x{curl -s -u #{ENV["EZNEWS_USER"]}:#{ENV["EZNEWS_PASS"]} "#{url}"}
  end

  out
end

get "/fetch2" do
  # debugger
  if @request.env.has_key?("HTTP_RANGE")
    puts "They want range! #{@request.env["HTTP_RANGE"]}"
  end
  
  if @request.env["HTTP_USER_AGENT"] =~ /iphone/i
    if @request.env.has_key?("HTTP_RANGE")
    else
    end
  else
    open(CACHE[params[:key]], 
      :http_basic_authentication => [ENV["EZNEWS_USER"], ENV["EZNEWS_PASS"]],     
      :content_length_proc => lambda {|c| header "Content-Type" => "audio/mp3", "Content-Length" => c.to_s; puts "content length is #{c}"},
      :progress_proc => lambda {|size| }
    )
  end
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