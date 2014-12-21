# coding: utf-8
require 'yaml'
require 'lib/downloader'
require 'lib/search_eamu'
require 'logger'
require 'bundler'
Bundler.require

class TwClient
    KEY_DATA_FILE = "config/twitter.yaml"
    
    include Download
    include SearchEamuAppTweet

    def initialize()
        @logger = Logger.new("log/eamu_download.log")
        @logger.level = Logger::DEBUG

        key_data = YAML.load_file(KEY_DATA_FILE)
        @client = Twitter::REST::Client.new do |config|
            key_data.keys.each do |keyname|
                eval("config.#{keyname} = key_data['#{keyname}'] ") 
            end
        end
    end

    def download(url)
        super 
        @logger.info("download: #{url}")
    rescue => e
        @logger.error("download error: " + e.message)
    end

end
