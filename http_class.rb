class Http_request
    attr_reader :type,:path,:protocol,:data
    def initialize(text)
        @type = text.split(" ")[0]
        @path = text.split(" ")[1]
        @protocol = text.split(" ")[2]
        tmp = {}
        text.split("\n")[1..-1].each do |row|
            key, val = row.split(": ")
            tmp[key.gsub("-","_").to_sym] = val
        end
        @data = tmp
    end

    def print()
        puts @protocol.red
        puts @type.red
        puts @path.red

        @data.each do |key,value|
            puts "#{key}: #{value}".yellow
        end
    end
end

class Http_response

    attr_accessor :content_type
    def initialize(body,status_code = 200)
        @protocol = "HTTP/1.1"

        tmp = {}
        File.readlines("http_codes.txt").each do |line|
            tmp[line[0,3].to_i] = line.chomp
        end

        @@status_codes = tmp
        
        @status_code = @@status_codes[status_code]
        if @status_code.nil?
            raise "invalid status code :#{status_code}"
        end
            
        @server = "olle_server"

        @body = body

        @content_type = "text/html; charset=utf-8"
    end

    def status_code(status_code)
        @status_code = @@status_codes[status_code]
        if @status_code.nil?
            raise "invalid status code :#{status_code}"
        end
    end



    def to_s
        "#{@protocol} #{@status_code}\r\nServer: #{@server}\r\nContent-Type: #{@content_type}\n\n#{@body}\n\n"
    end

end
