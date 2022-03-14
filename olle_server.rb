require 'socket'
require_relative 'colorize.rb'


class Olle_server

    def start()
        puts "\nStarted server\n".green
        loop do
            session = @server.accept
            puts "\n\nThe socket is: "+ session.to_s.yellow
            
            request = ""
            while (line = session.gets) and line !~ /^\s*$/
                request += line
            end
            request = parse_http(request)
            puts_request(request)

            send_response(request)
            
            session.close
        end
        
    end
    
    private

    #puts the hash wich contains the data to the terminal with colors
    def puts_request(request)
        request.each do |key,value|
            puts key.to_s.blue + " => " + value.red
        end
    end
        
    #parse a http requst to an hash
    def parse_http(text)
        out = {}
        out[:type] = text.split(" ")[0]
        out[:path] = text.split(" ")[1]
        out[:protocol] = text.split(" ")[2]
        text.split("\n")[1..-1].each do |row|
            key, val = row.split(": ")
            out[key.gsub("-","_").to_sym] = val
        end
        out
    end
    
    def gen_http_response(body)
        response = "HTTP/1.1 200 OK\nServer: Olle_server\n\n#{body}\n\n"
    end
    
    #initilazes the Olle_server object by creating a TCP server with the specified port
    def initialize(port)
        @server = TCPServer.new(port)
        @get_routes = {}
        @post_routes = {}
    end
    
    #add the provided block of code to the specified Get PATH
    def GET(path, &block)
        @get_routes[path] = block
    end
    
    #add the provided block of code to the specified post PATH
    def POST(path, &block)
        @post_routes[path] = block
    end

end