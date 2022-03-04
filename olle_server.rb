require 'socket'

def parse_http(text)
    out = {}
    out[:type] = text.match(/\w+/).to_s
    out[:path] = text.match(/(?<=\/)[\w.\/]+/).to_s
    out[:protocol] = text.split(" ")[2]
    text.split("\n")[1..-1].each do |row|
        key, val = row.split(": ")
        out[key.gsub("-","_").to_sym] = val
    end
    out
end

class Olle_server

    #initilazes the Olle_server object by creating a TCP server with the specified port
    def initialize(port)
        @server = TCPServer.new(port)
        @get_routes = {}
        @post_routes = {}
    end

    #add the provided block of code to the specified Get PATH
    def GET(path_sym, &block)
        @get_routes[path_sym] = block
    end
    
    #add the provided block of code to the specified post PATH
    def POST(path_sym, &block)
        @post_routes[path_sym] = block
    end


    def start()
        
end