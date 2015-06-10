# coding: utf-8
$LOAD_PATH.push(File.dirname(File.expand_path(__FILE__)))
require 'pp'
require 'optparse'
require 'lib/twclient'

def main(params)
    client = TwClient.new(params['config'])
    tweets = client.search

    tweets.each do |tweet|
        client.log_tweet(tweet)
        tweet[:images].each do |url|
            client.download(url)
        end
    end
end

if $0 == __FILE__
    main ARGV.getopts('', 'config:')
end
