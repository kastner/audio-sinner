Audio Sinner
============

It's 7:18am on Sunday, May 4th 2008 and I didn't sleep last night. Instead of sweet man-on-bed action, I coded a [micro-app](http://therealadam.com/archive/2007/11/23/the-rise-of-the-micro-app/ "Adam Keys on how awesome I am.") that's been jostling around in my head for a _very_ long time.

The concept is simple (and the code isn't that much harder. Really. Take a look), I wanted to combine [this one thing I have](http://www.apple.com/iphone/ "Apple - iPhone"), with [this other thing I totally love](http://easynews.com/ "EasyNews - Party like it's 1987"). Sort of a chocolate-in-peanutbutter power-play.


It's like the iTunes Music Store. Except Free. And Illegal. And _TOTALLY_ wrong
-----------------------------------------------------------------------------

So here's the infoz on how to get it running, but don't.

GEMS You'll wish you had installed
----------------------------------

* [Hpricot](http://code.whytheluckystiff.net/hpricot/ "Hpricot, a fast and delightful HTML parser")
* [aws/s3](http://amazon.rubyforge.org/ "AWS::S3 - Ruby Library for Amazon Simple Storage Service (S3)")
* [memcache-client](http://dev.robotcoop.com/Libraries/memcache-client/index.html "seattlerb's memcache-client-1.3.0 Documentation")


Other softwarez needed for the runnings
---------------------------------------

* [memcached](http://www.danga.com/memcached/ "memcached: a distributed memory object caching system")
* [ruby](http://www.ruby-lang.org/ "Ruby Programming Language")
* [sinatra](http://github.com/bmizerany/sinatra/tree/master "bmizerany's sinatra at master &mdash; GitHub") (I have it linked in PROJECT_ROOT/sinatra)


Services u payz 4
-----------------

* [s3](http://aws.amazon.com/s3 "Amazon.com: Amazon S3, Amazon Simple Storage Service, Unlimited Online Storage: Amazon Web Services")
* [easynews](http://www.newsgroupreviews.com/easynews-review.html "Easynews Review - Compare Easynews to 50+ Usenet Providers")


Unsecure your shiz
------------------

* Put your s3 credentials in .amazon_keys, just like marcel tells you
* Put your eznews credentials in .eznews_creds, just like I tells you
* source those two files in your start up script, or server environment of your choice

That is all.

![sinner](http://img.skitch.com/20080504-e5ajxaua1n5f3gw7nidh2wyfkt.png "This doesn't exist")