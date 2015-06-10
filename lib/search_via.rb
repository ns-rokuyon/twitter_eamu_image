# coding: utf-8
require 'logger'
require 'bundler'
Bundler.require

module SearchViaTweet

    def search(show=false)
        results = []
        via   = @conf["via"]
        query = @conf["query"]
        count = @conf["count"] || 100

        @client.search("#{query} source:\"#{via}\"", :count => count, :result_type => "recent")
        .attrs[:statuses].each do |tweet|
            pp tweet if show

            # リツイートが多いツイートは拾わない
            next if tweet[:retweet_count] > 10

            res = { 
                :text => tweet[:text],
                :id => tweet[:id],
                :userid => tweet[:user][:screen_name],
                :retweet_count => tweet[:retweet_count],
                :images => []
            }

            if tweet[:entities] && tweet[:entities][:media]
                tweet[:entities][:media].each do |media|
                    res[:images].push(media[:media_url])
                end 
                # mediaがあるツイートのみ拾う
                results.push(res)
            end
        end
        
        @logger.info("tweet num: #{results.size}")
        results
    end

    def log_tweet(tweet)
        logtext = "id:#{tweet[:id]}, rt:#{tweet[:retweet_count]}"
        tweet[:images].each_with_index do |url,i|
            logtext += ", image[#{i}]:#{url}"
        end
        @logger.info(logtext)
    end
end
