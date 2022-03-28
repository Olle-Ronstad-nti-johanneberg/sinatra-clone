class Http_request
    attr_reader :type,:path,:protocol,:data
    def initialize(text)
        @type = text.split(" ")[0]
        @path = text.split(" ")[1]
        @protocol = text.split(" ")[2]
        tmp = {}
        text.split("\n")[1..-1].each do |row|
            key, val = row.split(": ")
            tmp[key] = val
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

    attr_accessor :body
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

        @body = body
        @header = {
            "Content-Type" => "text/html; charset=utf-8",
            "Server" => "olle_server"
        }
    end

    def status_code(status_code)
        @status_code = @@status_codes[status_code]
        if @status_code.nil?
            raise "invalid status code :#{status_code}"
        end
    end

    def to_s
        "#{@protocol} #{@status_code}\r\n#{
            @header.to_a.map do |key,value|
                key + ": " + value
            end.join("\r\n")

        }\n\n#{@body}\n\n"
    end

    def redirect(link)
        @status_code = @@status_codes[301]
        @header["Location"] = link
    end

    def content_type=(type)
        @header["Content-Type"] = type
    end

    def header
        @header
    end

end
