# coding: utf-8
$LOAD_PATH.push(File.dirname(File.expand_path(__FILE__)))
require 'pp'
require 'lib/twclient'

def main()
    client = TwClient.new
    tweets = client.search()

    tweets.each do |tweet|
        client.log_tweet(tweet)
        tweet[:images].each do |url|
            client.download(url)
        end
    end
end

if $0 == __FILE__
    main
end
