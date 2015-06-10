# coding: utf-8
require 'yaml'
require 'lib/downloader'
require 'lib/search_via'
require 'logger'
require 'bundler'
Bundler.require

class TwClient
    KEY_DATA_FILE = "config/twitter.yaml"
    
    include Download
    include SearchViaTweet

    def initialize(configfile)
        key_data = YAML.load_file(KEY_DATA_FILE)
        configure(configfile)

        @client = Twitter::REST::Client.new do |config|
            key_data.keys.each do |keyname|
                eval("config.#{keyname} = key_data['#{keyname}'] ") 
            end
        end
    end

    def configure(configfile)
        @conf = YAML.load_file(configfile)

        logfile = @conf["log"] || "crawler.log"
        @logger = Logger.new("log/#{logfile}")
        @logger.level = Logger::DEBUG
    rescue
        raise CrawlerError, "failed to initialize"
    end

    def download(url)
        super 
        @logger.info("download: #{url}")
    rescue => e
        @logger.error("download error: " + e.message)
    end

end
