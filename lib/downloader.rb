require "open-uri"
require "fileutils"

module Download

    def download(url)
        file_name = File.basename(url)
        file_path = directory() + '/' + file_name

        open(file_path, 'wb') do |file|
            open(url) do |data|
                file.write(data.read)
            end
        end
    end

    def directory()
        dir = (@conf["savedir"] || "/tmp") + '/' + Time.now.strftime("%Y/%m/%d/%H")
        FileUtils.mkdir_p(dir)

        dir
    end
end
