require "open-uri"
require "fileutils"

module Download
    SAVE_DIR_ROOT = "/home/ns64/images/input/eamu"

    def download(url)
        file_name = File.basename(url)
        file_path = directory() + '/' + file_name

        open(file_path, 'wb') do |file|
            open(url) do |data|
                file.write(data.read)
            end
        end
    rescue
        raise
    end

    def directory()
        dir = SAVE_DIR_ROOT + '/' + Time.now.strftime("%Y/%m/%d/%H")
        FileUtils.mkdir_p(dir)

        dir
    end
end
