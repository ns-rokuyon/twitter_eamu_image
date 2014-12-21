# coding: utf-8
require 'logger'
require 'bundler'
Bundler.require

module SearchEamuAppTweet
    EAMU_VIA = "eAMUSEMENT"

    def search(show=false)
        results = []
        query = "a OR aa OR aaa OR クリア OR 弐寺 OR リフレク OR jubeat OR ボルテ OR HARD OR EXT OR 難 OR ハード OR フルコン OR ノマゲ OR 易 OR ☆ "

        @client.search("#{query} source:#{EAMU_VIA}", :count => 100, :result_type => "recent")
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
