require 'securerandom'


class Http_request
    attr_reader :type,:path,:protocol,:headers,:cookie,:params
    def initialize(text)

        @type = text.split(" ")[0]
        @path = text.split(" ")[1].split("?")[0]
        @protocol = text.split(" ")[2]

        text = text.split("\n")
        if @type == "POST"
            body = text.pop
        elsif @type == "GET"
            body = text[0].split(" ")[1].split("?")[1]
        end
        tmp = {}

        if !body.nil?
            body.split("&").each do |row|
                key, val = row.split("=")
                tmp[key] = val
            end
        end
        @params = tmp



        tmp = {}
        text[1..-1].each do |row|
            key, val = row.split(": ")
            tmp[key] = val
        end
        @headers = tmp

        tmp = {}

        if !@headers["Cookie"].nil?
            @headers["Cookie"].split("; ").each do |cookie|
                key, val = cookie.split("=")
                tmp[key] = val
            end
        end
        @cookie = tmp

    end

    def print()
        puts @protocol.light_blue
        puts @type.light_blue
        puts @path.light_blue

        @headers.each do |key,value|
            puts "#{key}: #{value}".light_blue
        end
        puts ""
        @params.each do |key,value|
            puts "#{key} = #{value}".light_blue
        end
    end
end

class Http_response

    attr_accessor :body, :cookies
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

        @cookies = {}
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
            end.join("\r\n")}\r\n#{

            @cookies.to_a.map do |key,value|
                "Set-Cookie: " + key + "=" + value
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

    def print()
        puts self.to_s.green
    end
end



class HTTP_response_image
    def initialize(file)
        @protocol ="HTTP/1.1"
        @status_code = "200 OK"
        @body = File.open("public#{file}", "rb").read
        @header = {
            "Content-Type" => "image/#{file.split(".")[-1]}; charset=utf-8",
            "Server" => "olle_server"
        }
    end

    def to_s
        "#{@protocol} #{@status_code}\r\n#{
            @header.to_a.map do |key,value|
                key + ": " + value
            end.join("\r\n")

        }\n\n#{@body}\n\n"
    end

    def print
        puts "#{@protocol} #{@status_code}\r\n#{
            @header.to_a.map do |key,value|
                key + ": " + value
            end.join("\r\n")

        }\n\nimage".green
    end
end